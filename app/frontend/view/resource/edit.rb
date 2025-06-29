# frozen_string_literal: true

class View::Resource::Edit < Phlex::HTML
  include Phlex::Rails::Helpers::FormFor
  include Phlex::Rails::Helpers::LinkTo
  include Phlex::Rails::Helpers::Routes
  include Phlex::Rails::Helpers::ControllerName
  include Phlex::Rails::Helpers::URLFor
  include Phlex::Rails::Helpers::TurboFrameTag
  include ResourceNaming

  attr_reader :resource, :action, :notice

  def initialize(resource, action:, notice: nil)
    @resource = resource
    @action = action
    @notice = notice
  end

  def view_template
    div(class: "mx-4 my-6 md:mx-6 lg:mx-8") do
      Components::Card(title: "Edit #{resource.class.name}") do
        turbo_frame_tag "resource_form" do
          render edit_form.new(resource, action: action)
        end

        subform_relations.each do |sub_resource|
          render subform_view_for(sub_resource).new(resource: resource, sub_resource: sub_resource)
        end
      end
    end
  end

  def edit_form
    @edit_form ||=
      if Object.const_defined?("View::#{resource_plural}::EditForm")
        "View::#{resource_plural}::EditForm".constantize
      else
        View::Resource::EditForm
      end
  end

  def subform_view_for(sub_resource)
    sub_resource_viewname = sub_resource.camelcase.pluralize
    if Object.const_defined?("View::#{sub_resource_viewname}::SubForm")
      "View::#{sub_resource}::SubForm".constantize
    else
      View::Resource::SubForm
    end
  end

  def subform_relations
    @subform_attributes ||= resource.class.reflect_on_all_associations
      .reject(&:through_reflection?)
      .select { |assoc| assoc.macro == :has_many }
      .map { |assoc| assoc.name.to_s }
      .reject { |assoc| Object.const_get("#{resource_plural}Controller::NO_SUBFORM_RELATIONS").include?(assoc) }
  end
end
