class View::BuildItems::TableFrame < Phlex::HTML
  # include Phlex::Rails::Helpers::LinkTo
  # include Phlex::Rails::Helpers::URLFor
  # include Phlex::Rails::Helpers::TurboFrameTag
  # include Phlex::Rails::Helpers::TurboFrameTag
  include Phlex::Rails::Helpers::FormFor
  include Phlex::Rails::Helpers::LinkTo
  include Phlex::Rails::Helpers::Routes
  include Phlex::Rails::Helpers::ControllerName
  include Phlex::Rails::Helpers::URLFor
  include Phlex::Rails::Helpers::FormTag
  include Phlex::Rails::Helpers::FormWith
  include Phlex::Rails::Helpers::SelectTag
  include Phlex::Rails::Helpers::TurboFrameTag

  attr_reader :build

  def initialize(build:)
    @build = build
  end

  def view_template
    turbo_frame_tag "build_items_table_frame" do
      div(id: "build_items_table", class: "mt-6") do
        h3(class: "text-lg font-semibold mb-2") { "Build Items" }
        if build.items.any?
          table(class: "min-w-full divide-y divide-gray-200 dark:divide-gray-700") do
            thead(class: "bg-gray-50 dark:bg-slate-700") do
              tr do
                th(class: "px-6 py-3 text-left text-xs font-medium text-gray-500 dark:text-gray-200 uppercase tracking-wider") { "Name" }
                th(class: "px-6 py-3 text-left text-xs font-medium text-gray-500 dark:text-gray-200 uppercase tracking-wider") { "Act" }
                th(class: "px-6 py-3 text-left text-xs font-medium text-gray-500 dark:text-gray-200 uppercase tracking-wider") { "Actions" }
              end
            end
            tbody(id: "items_table_body", class: "bg-white dark:bg-slate-800 divide-y divide-gray-200 dark:divide-gray-700") do
              build.items.each do |item|
                tr do
                  td(class: "px-6 py-4 whitespace-nowrap text-sm text-gray-500 dark:text-gray-300") { item.name }
                  td(class: "px-6 py-4 whitespace-nowrap text-sm text-gray-500 dark:text-gray-300") { item.act }
                  td(class: "px-6 py-4 whitespace-nowrap text-sm") do
                    build_item = build.build_items.find_by(item_id: item.id)
                    link_to("Remove",
                          url_for(controller: "build_items", action: "destroy", id: build_item.id),
                          data: { turbo_method: :delete, turbo_confirm: "Are you sure you want to remove this item?" },
                          class: "text-red-600 hover:text-red-900 dark:text-red-500 dark:hover:text-red-400")
                  end
                end
              end
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
end
