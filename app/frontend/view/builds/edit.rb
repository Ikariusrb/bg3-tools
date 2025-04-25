class View::Builds::Edit < Phlex::HTML
  include Phlex::Rails::Helpers::FormFor
  include Phlex::Rails::Helpers::LinkTo
  include Phlex::Rails::Helpers::Routes
  include Phlex::Rails::Helpers::ControllerName
  include Phlex::Rails::Helpers::URLFor
  include Phlex::Rails::Helpers::FormTag
  include Phlex::Rails::Helpers::FormWith
  include Phlex::Rails::Helpers::SelectTag

  attr_reader :resource, :action, :notice

  def initialize(resource, action:, notice: nil)
    @resource = resource
    @action = action
    @notice = notice
  end

  def view_template
    div(class: "mx-4 my-6 md:mx-6 lg:mx-8") do
      Components::Card(title: "Edit build") do
        form_for(resource) do |f|
          resource.attributes.except(*%w[id created_at updated_at]).transform_keys(&:to_sym).each do |attribute, value|
            div do
              f.label attribute
              f.text_field attribute
            end
          end

          div do
            form_actions(f)
          end
        end

          form_with(url: url_for(controller: "build_items", action: "create"), method: :post, class: "inline-block") do |f|
            input(type: "hidden", name: "build_item[build_id]", value: resource.id)
            input(type: "hidden", name: "build_item[item_id]", id: "selected_item_id")
            # Add items section with dropdown and add button
            div(class: "mt-4", data: { controller: "builds" }) do
              div(class: "flex items-end space-x-2") do
                div(class: "flex-grow") do
                  f.label "Items"
                  f.select(:items, Item.pluck(:name, :id), {}, { data: { controller: 'slim-select', slim_target: 'field' }, class: "w-full" })
                end

                button(type: "submit", class: "bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded focus:outline-none focus:shadow-outline",
                  data: { action: "builds#addSelectedItem" }) do
                  "Add Item"
                end
              end
            end
          end

          # Add table to display associated items
          div(class: "mt-6") do
            h3(class: "text-lg font-semibold mb-2") { "Associated Items" }
            if resource.items.any?
              table(class: "min-w-full divide-y divide-gray-200 dark:divide-gray-700") do
                thead(class: "bg-gray-50 dark:bg-slate-700") do
                  tr do
                    th(class: "px-6 py-3 text-left text-xs font-medium text-gray-500 dark:text-gray-200 uppercase tracking-wider") { "Name" }
                    th(class: "px-6 py-3 text-left text-xs font-medium text-gray-500 dark:text-gray-200 uppercase tracking-wider") { "Act" }
                    th(class: "px-6 py-3 text-left text-xs font-medium text-gray-500 dark:text-gray-200 uppercase tracking-wider") { "Actions" }
                  end
                end
                tbody(class: "bg-white dark:bg-slate-800 divide-y divide-gray-200 dark:divide-gray-700") do
                  resource.items.each do |item|
                    tr do
                      td(class: "px-6 py-4 whitespace-nowrap text-sm text-gray-500 dark:text-gray-300") { item.name }
                      td(class: "px-6 py-4 whitespace-nowrap text-sm text-gray-500 dark:text-gray-300") { item.act }
                      td(class: "px-6 py-4 whitespace-nowrap text-sm") do
                        build_item = resource.build_items.find_by(item_id: item.id)
                        link_to("Remove", url_for(controller: "build_items", action: "destroy", id: build_item.id),
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

  def options_for_select(collection)
    collection
      .map { |display, value| "<option value='#{value}'>#{display}</option>" }
      .join
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
