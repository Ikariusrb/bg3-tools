# frozen_string_literal: true

class View::Builds::EditForm < Phlex::HTML
  include Phlex::Rails::Helpers::FormFor
  include Phlex::Rails::Helpers::LinkTo
  include Phlex::Rails::Helpers::Routes
  include Phlex::Rails::Helpers::ControllerName
  include Phlex::Rails::Helpers::URLFor
  include Phlex::Rails::Helpers::FormTag
  include Phlex::Rails::Helpers::FormWith
  include Phlex::Rails::Helpers::SelectTag
  include Phlex::Rails::Helpers::TurboFrameTag
  register_value_helper :heroicon

  attr_reader :resource, :action

  def initialize(resource, action: 'edit')
    @resource = resource
    @action = action
  end

  def view_template
    form_for(resource) do |f|
      resource.attributes.except(*%w[id created_at updated_at]).transform_keys(&:to_sym).each do |attribute, value|
        div(class: 'space-x-2 my-2') do
          f.label(attribute, class: 'inline-block text-right w-20')
          f.text_field attribute
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
end
