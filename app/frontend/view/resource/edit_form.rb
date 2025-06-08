# frozen_string_literal: true

class View::Resource::EditForm < Phlex::HTML
  include Phlex::Rails::Helpers::FormFor
  include Phlex::Rails::Helpers::LinkTo
  include Phlex::Rails::Helpers::Routes
  include Phlex::Rails::Helpers::ControllerName
  include Phlex::Rails::Helpers::URLFor

  attr_reader :resource, :action, :notice

  def initialize(resource, action:, notice: nil)
    @resource = resource
    @action = action
    @notice = notice
  end

  def view_template
    form_for(resource) do |f|
      resource_attributes.each do |attribute, value|
        if attribute_types[attribute] == :enum
          div(class: 'space-x-2 my-2') do
            f.label(attribute, class: 'inline-block text-right w-20')
            type_options = resource.defined_enums[attribute.to_s].to_a.sort_by(&:first).map(&:first)
            f.select(attribute, type_options, { include_blank: false }, { data: { controller: 'slim_select', slim_target: 'field' } })
          end
        else
          div(class: 'space-x-2 my-2') do
            f.label(attribute, class: 'inline-block text-right w-20')
            f.text_field attribute
          end
        end
      end

      form_actions(f)
    end
  end

  def form_actions(form)
    div(class: 'space-x-2 my-2') do
      form.submit("Save", class: "bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded focus:outline-none focus:shadow-outline")
      if action == :new
        link_to("Cancel", url_for(action: :index))
      else
        link_to("Cancel", url_for(resource))
      end
    end
  end

  private

  def resource_attributes
    resource.attributes.except(*%w[id created_at updated_at]).transform_keys(&:to_sym)
  end

  def attribute_types
    @attribute_types ||= resource.class.columns
      .reject { |c| %w[id created_at updated_at].include?(c.name) }
      .to_h do |c|
        if resource_enums.include?(c.name)
          [c.name.to_sym, :enum]
        else
          [c.name.to_sym, c.type]
        end
      end
  end

  def resource_enums
    @resource_enums ||= resource.defined_enums.keys
  end
end
