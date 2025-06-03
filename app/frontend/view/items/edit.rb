# frozen_string_literal: true

class View::Items::Edit < Phlex::HTML
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
    Components::Card(title: "Edit Item", extra_css: %w[m-8]) do
      form_for(resource) do |f|
        resource.attributes.except(*%w[id created_at updated_at item_type]).transform_keys(&:to_sym).each do |attribute, value|
          div do
            f.label attribute
            f.text_field attribute
          end
        end
        type_options = resource.defined_enums['item_type'].keys.sort
        f.label 'item_type'
        f.select(:item_type, type_options, { include_blank: false }, { data: { controller: 'slim_select', slim_target: 'field' } })
        div do
          form_actions(f)
        end
      end
    end
  end

  def form_actions(form)
    form.submit("Save", class: "bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded focus:outline-none focus:shadow-outline")
    if action == :new
      link_to("Cancel", url_for(action: :index))
    else
      link_to("Cancel", url_for(resource))
    end
  end
end
