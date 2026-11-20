# frozen_string_literal: true

require 'yaml'
require 'pathname'

module Deployment
  # Resolved configuration for bg3-tools' single deployment.
  #
  # The counterpart of Tenant::Config in janus-admin-core and cp2020, for an app with one
  # deployment rather than one per tenant: project settings come from config/tools.yml, and
  # the chart's values live directly in deploy/helm/ instead of a per-tenant directory.
  #
  #   Deployment::Config.build
  class Config
    REPO_ROOT       = Pathname.new(File.expand_path('../../..', __dir__)).freeze
    HELM_ROOT       = (REPO_ROOT / 'deploy' / 'helm').freeze
    TOOLS_CONFIG    = (REPO_ROOT / 'config' / 'tools.yml').freeze
    MASTER_KEY_PATH = (REPO_ROOT / 'config' / 'credentials' / 'production.key').freeze

    REQUIRED_SETTINGS = %w[application registry namespace environment].freeze

    class Error < StandardError; end

    attr_reader :application, :registry, :namespace, :environment

    def self.build
      new.tap(&:validate!)
    end

    def initialize
      @settings    = load_settings
      @application = @settings['application']
      @registry    = @settings['registry']
      @namespace   = @settings['namespace']
      @environment = @settings['environment']
    end

    def validate!
      missing = REQUIRED_SETTINGS.select { |key| @settings[key].to_s.empty? }
      raise Error, "#{TOOLS_CONFIG} is missing: #{missing.join(', ')}" if missing.any?
      raise Error, "Missing values file: #{values_file}"   unless values_file.file?
      raise Error, "Missing secrets-values file: #{secrets_file}" unless secrets_file.file?

      self
    end

    # Helm release name, and the app.kubernetes.io/instance label on its pods.
    def release_name
      application
    end

    def image_repository
      "#{registry}/#{application}"
    end

    def values_file
      HELM_ROOT / 'values.yaml'
    end

    def secrets_file
      HELM_ROOT / 'secrets-values.yaml'
    end

    # Mirrors the SealedSecret name in deploy/helm/templates/sealed_master_key_secret.yaml.
    def master_key_secret_name
      "#{application}-master-key"
    end

    private

    def load_settings
      YAML.load_file(TOOLS_CONFIG) || {}
    rescue Errno::ENOENT
      raise Error, "tools config not found at #{TOOLS_CONFIG}"
    end
  end
end
