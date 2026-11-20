# frozen_string_literal: true

module Ops
  module Tasks
    module Console
      class Shell < Ops::DeploymentTask
        include Ops::PodExec

        desc 'console:shell', 'Open a bash shell in the running pod'

        def call
          open_deployment_pod(command: 'bash', label: 'shell')
        end
      end
    end
  end
end
