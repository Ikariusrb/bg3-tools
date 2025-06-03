# frozen_string_literal: true

# /home/rbecker/code/bg3-tools/app/views/items/show.rb

class View::Resource::Show < Phlex::HTML
  include Phlex::Rails::Helpers::LinkTo
  include Phlex::Rails::Helpers::Routes
  include Phlex::Rails::Helpers::Routes
  include Phlex::Rails::Helpers::ControllerName
  include Phlex::Rails::Helpers::URLFor

  attr_reader :resource, :notice

  def initialize(resource, notice: nil)
    @resource = resource
    @notice = notice
  end

  def view_template
    p(style: "color:#008000") { notice }
    ul do
      resource.attributes.except("id").each do |key, value|
        li { "#{key}: #{value}" }
      end
    end
    link_to "All #{resource.class.name.pluralize}",
      url_for(action: :index),
      class:
        "bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded focus:outline-none focus:shadow-outline"
  end
end
