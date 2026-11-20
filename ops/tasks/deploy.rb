# frozen_string_literal: true

module Ops
  module Tasks
    class Deploy < Ops::DeploymentTask
      desc 'deploy', 'Deploy via helm upgrade --install'

      def task_options
        opts.option :dry_run, type: :boolean, default: false,
          desc: 'Render and validate the chart without applying changes'
      end

      def call
        puts "Release:   #{deployment.release_name}"
        puts "Namespace: #{deployment.namespace}"
        puts "Version:   #{version}"
        puts "Mode:      #{opts.dry_run ? 'DRY RUN' : 'LIVE DEPLOYMENT'}"
        puts '-' * 80

        Dir.chdir(Deployment::Config::HELM_ROOT.to_s) do
          Ops::Shell.run(*helm_command, display: true)
        end

        puts '=' * 80
        puts opts.dry_run ? "DRY RUN COMPLETE - to deploy for real, run: bin/ops deploy" : "✓ Successfully deployed #{deployment.release_name}"
        puts '=' * 80
      end

      private

      def version
        @version ||= Ops::Shell.capture('git', 'rev-parse', '--short=8', 'HEAD').chomp
      end

      def helm_command
        cmd = [
          'helm', 'upgrade', deployment.release_name, '.',
          '--install',
          '--set', "version=#{version}",
          '--set', "appName=#{deployment.application}",
          '--set', "environment=#{deployment.environment}",
          '--namespace', deployment.namespace,
          '--values', deployment.values_file.to_s,
          '--values', deployment.secrets_file.to_s
        ]
        cmd += ['--dry-run', '--debug'] if opts.dry_run
        cmd
      end
    end
  end
end
