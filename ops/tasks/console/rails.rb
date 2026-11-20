# frozen_string_literal: true

module Ops
  module Tasks
    module Console
      class Rails < Ops::DeploymentTask
        include Ops::PodExec

        desc 'console:rails', 'Open a Rails console in the running pod'

        def call
          open_deployment_pod(command: 'clear; bin/rails c', label: 'Rails console')
        end
      end
    end
  end
end
