# frozen_string_literal: true

class View::BuildItems::SubFrame < Phlex::HTML
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

  attr_reader :build

  def initialize(build:)
    @build = build
  end

  def view_template
    turbo_frame_tag "build_items_sub_frame" do
      div(id: "build_items_table", class: "mt-6") do
        if build.items.any?
          render Components::Table.new(build.build_items) do |t|
            t.column("Name") { |build_item| build_item.item.name }
            t.column("Act") { |build_item| build_item.item.act }
            t.column("Actions") do |build_item|
              delete_action(build_item)
            end
          end
        else
          div(class: "text-center p-4 text-gray-500 dark:text-gray-400") do
            "No items added to this build yet."
          end
        end
      end
    end
  end

  def delete_action(build_item)
    link_to(
      url_for(build_item),
      data: {
        turbo_method: :delete,
        turbo_confirm: "Are you certain you want to delete this?"
      },
      class: 'inline-block'
    ) { span(class: "svg-image") { heroicon("trash", variant: :mini) } }
  end
end
