# frozen_string_literal: true

module ResourceNaming
  extend ActiveSupport::Concern

  def self.included(klass)
    # Code to run when the module is included in a class
    klass.class_eval do
      def resource_plural
        @resource_plural ||=
          if defined?(RESOURCE)
            RESOURCE.camelcase.pluralize
          else
            self.class.name.delete_suffix("Controller")
          end
      end

      def resource_singular
        @resource_singular ||= resource_plural.singularize
      end

      def model
        @resource_model ||= resource_singular.constantize
      end

      if defined?(PARENT_RESOURCE)
        def parent_resource_plural
          @parent_resource_plural ||= PARENT_RESOURCE.camelcase.pluralize
        end

        def parent_resource_singular
          @parent_resource_singular ||= parent_resource_plural.singularize
        end
      end
    end
  end
end
