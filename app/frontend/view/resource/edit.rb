# frozen_string_literal: true

class View::Resource::Edit < Phlex::HTML
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
      resource.attributes.except(*%w[id created_at updated_at]).transform_keys(&:to_sym).each do |attribute, value|
        div do
          f.label attribute
          f.text_field attribute
        end
      end

      div do
        f.submit("Save", class: "bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded focus:outline-none focus:shadow-outline")
        if action == :new
          link_to("Cancel", url_for(action: :index))
        else
          link_to("Cancel", url_for(resource))
        end
      end
    end
  end
end
