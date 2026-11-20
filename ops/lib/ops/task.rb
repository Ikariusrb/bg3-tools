# frozen_string_literal: true

require 'janus_ops'

require_relative '../deployment/config'

# Repo-local extension of janus-ops' Ops::Task for an app with a single deployment.
# janus-admin-core and cp2020 have Ops::TenantTask, which takes a TENANT argument; here
# every task targets the one deployment described by config/tools.yml.
module Ops
  class DeploymentTask < Task
    def deployment
      @deployment ||= Deployment::Config.build
    end

    # Thin wrapper around Ops::PodExec#open_in_pod that supplies the deployment's
    # namespace and release. Requires the including task to mix in Ops::PodExec.
    def open_deployment_pod(command:, label:)
      open_in_pod(
        namespace: deployment.namespace,
        release_name: deployment.release_name,
        target: deployment.application,
        command: command,
        label: label
      )
    end
  end
end
