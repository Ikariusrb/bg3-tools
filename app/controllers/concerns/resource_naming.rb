# frozen_string_literal: true

module ResourceNaming
  extend ActiveSupport::Concern

  def self.included(klass)
    # Code to run when the module is included in a class
    klass.class_eval do
      def resource_base
        @resource_base ||=
          if self.class.const_defined?(:RESOURCE)
            self.class.const_get(:RESOURCE)
          elsif defined?(resource)
            resource.class.name
          elsif defined?(resources) && resources.any?
            resources.first.class.name
          elsif defined?(controller_name)
            controller_name
          else
            self.class.name.delete_suffix("Controller")
          end
      end

      def resource_plural
        @resource_plural ||= resource_base.camelcase.pluralize
      end

      def resource_singular
        @resource_singular ||= resource_plural.singularize
      end

      def resource_snake_plural
        @resource_snake_plural ||= resource_plural.underscore.pluralize
      end

      def resource_snake_singular
        @resource_snake_singular ||= resource_snake_plural.singularize
      end

      def resource_title
        @resource_title ||= resource_singular.titleize
      end

      def model
        @resource_model ||= resource_singular.constantize
      end

      if const_defined?(:PARENT_RESOURCE)
        def parent_resource_plural
          @parent_resource_plural ||= const_get(:PARENT_RESOURCE).camelcase.pluralize
        end

        def parent_resource_singular
          @parent_resource_singular ||= parent_resource_plural.singularize
        end
      end
    end
  end
end
