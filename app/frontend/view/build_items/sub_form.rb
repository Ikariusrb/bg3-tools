# frozen_string_literal: true

class View::BuildItems::SubForm < Phlex::HTML
  include Phlex::Rails::Helpers::FormFor
  include Phlex::Rails::Helpers::URLFor
  include Phlex::Rails::Helpers::FormWith
  register_value_helper :heroicon

  attr_reader :resource, :sub_resource, :id

  def initialize(resource:, sub_resource: nil, id: nil)
    @resource = resource
    @sub_resource = sub_resource
    @id = id
  end

  def view_template
    h3(class: "text-lg font-semibold mb-0 mt-4") { "Build Items" }
    form_with(
      url: url_for(controller: "build_items", action: "create"),
      id: id || "build_items",
      class: "inline-block mt-0 pt-0",
      format: :turbo_stream,
      local: false,
      data: { turbo: true, turbo_stream: true, controller: 'builds', builds_target: 'form' }
    ) do |f|
      input(type: "hidden", name: "build_item[build_id]", value: resource.id)
      input(type: "hidden", name: "build_item[item_id]", id: "#{id}_select_target")
      # Add items section with dropdown and add button
      div(class: "flex space-x-2 items-center min-w-60") do
        f.select(:items, Item.pluck(:name, :id), {}, { data: { controller: 'slim-select', slim_target: 'field', builds_target: 'select' }, class: "w-full" })

        button(type: "submit", data: { action: "builds#addSelectedItem" }) { heroicon("plus-circle", variant: :outline) }
      end
    end

    # Add table to display associated items
    div do
      render View::BuildItems::SubFrame.new(build: resource)
    end
  end
end
