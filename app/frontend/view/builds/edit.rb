class View::Builds::Edit < Phlex::HTML
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


  attr_reader :resource, :action, :notice

  def initialize(resource, action:, notice: nil)
    @resource = resource
    @action = action
    @notice = notice
  end

  def view_template
    div(class: "mx-4 my-6 md:mx-6 lg:mx-8") do
      Components::Card(title: "Edit build") do
        turbo_frame_tag "build_form" do
          render View::Builds::EditForm.new(resource, action: action)
        end

        h3(class: "text-lg font-semibold mb-0 mt-4") { "Build Items" }
        form_with(
          url: url_for(controller: "build_items", action: "create"),
          id: "build_items",
          class: "inline-block mt-0 pt-0",
          format: :turbo_stream,
          local: false,
          data: { turbo: true, turbo_stream: true, controller: 'builds', builds_target: 'form' }
          ) do |f|
          input(type: "hidden", name: "build_item[build_id]", value: resource.id)
          input(type: "hidden", name: "build_item[item_id]", id: "selected_item_id")
          # Add items section with dropdown and add button
          div do
            div(class: "flex items-end space-x-2 items-center") do
              div(class: "flex-grow") do
                f.select(:items, Item.pluck(:name, :id), {}, { data: { controller: 'slim-select', slim_target: 'field', builds_target: 'select' }, class: "w-full" })
              end

              button(type: "submit", data: { action: "builds#addSelectedItem" }) do
                heroicon("plus-circle", variant: :outline)
              end
            end
          end
        end

        # Add table to display associated items
        div do
          render View::BuildItems::TableFrame.new(build: resource)
        end
      end
    end
  end
end
