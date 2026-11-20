# frozen_string_literal: true

require 'date'

module Ops
  module Tasks
    class Build < Ops::DeploymentTask
      desc 'build', 'Build and push the application Docker image'

      CACHE_BUST_DAYS      = 7
      LAST_CACHE_BUST_FILE = (Deployment::Config::REPO_ROOT / 'tmp' / '.last_cache_bust').freeze

      def task_options
        opts.option :force_rebuild, type: :boolean, default: false,
          desc: 'Force cache bust regardless of last-bust date'
      end

      def call
        if ENV['GITHUB_TOKEN'].to_s.empty?
          raise 'GITHUB_TOKEN not set — required for private gem access'
        end

        bust = opts.force_rebuild || cache_stale?

        puts "Last cache bust: #{days_since_bust} days ago"
        puts "Cache busting:   #{bust}"
        puts "Build tag:       #{build_tag}"
        puts '-' * 80

        Dir.chdir(Deployment::Config::REPO_ROOT.to_s) do
          run_build!(bust: bust)
          File.write(LAST_CACHE_BUST_FILE, Date.today.to_s) if bust
          run_push!
        end

        puts '=' * 80
        puts "✓ Built and pushed #{build_tag}"
        puts '=' * 80
      end

      private

      def git_version
        @git_version ||= Ops::Shell.capture('git', 'rev-parse', '--short=8', 'HEAD').chomp
      end

      def build_tag
        @build_tag ||= "#{deployment.image_repository}:#{git_version}"
      end

      def last_bust_date
        @last_bust_date ||= File.exist?(LAST_CACHE_BUST_FILE) \
          ? Date.parse(File.read(LAST_CACHE_BUST_FILE).strip)
          : Date.new(1970, 1, 1)
      end

      def days_since_bust
        (Date.today - last_bust_date).to_i
      end

      def cache_stale?
        days_since_bust > CACHE_BUST_DAYS
      end

      def run_build!(bust:)
        cmd = %w[docker buildx build --platform linux/amd64]
        cmd << '--pull' if bust
        cmd += ['--build-arg', "CACHE_DATE=#{Date.today.strftime('%Y-W%U')}"] if bust
        cmd += ['--secret', 'id=github_token,env=GITHUB_TOKEN']
        cmd += ['-t', build_tag, '.']

        Ops::Shell.run(*cmd, display: true)
      end

      def run_push!
        Ops::Shell.run('docker', 'push', build_tag, display: true)
      end
    end
  end
end
