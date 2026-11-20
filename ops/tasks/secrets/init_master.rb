# frozen_string_literal: true

require 'yaml'

module Ops
  module Tasks
    module Secrets
      class InitMaster < Ops::DeploymentTask
        desc 'secrets:init-master',
          'Seal config/credentials/production.key into deploy/helm/secrets-values.yaml (skipped if already sealed; --force reseals)'

        def task_options
          opts.option :force, type: :boolean, default: false,
            desc: 'Reseal even if a sealed master key is already present'
        end

        def already_done?
          !opts.force && !sealed_master_key.to_s.empty?
        end

        def call
          sealed = Ops::SecretSealer.new(namespace: deployment.namespace).seal(
            secret_name: deployment.master_key_secret_name,
            values: { 'RAILS_MASTER_KEY' => master_key }
          )
          write_secret_values(secret_values.merge('sealed_secrets' => sealed_secrets.merge(sealed)))

          puts "✓ Sealed master key → #{deployment.secrets_file}"
        end

        private

        def master_key
          File.read(Deployment::Config::MASTER_KEY_PATH).strip
        rescue Errno::ENOENT
          raise "Master key not found at #{Deployment::Config::MASTER_KEY_PATH}"
        end

        def secret_values
          @secret_values ||= YAML.load_file(deployment.secrets_file) || {}
        end

        def sealed_secrets
          secret_values['sealed_secrets'] || {}
        end

        def sealed_master_key
          sealed_secrets['RAILS_MASTER_KEY']
        end

        def write_secret_values(values)
          File.write(deployment.secrets_file, values.to_yaml)
        end
      end
    end
  end
end
