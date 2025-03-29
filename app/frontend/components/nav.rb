# frozen_string_literal: true

class Components::Nav < Components::Base
  include Phlex::Rails::Helpers::Routes
  include Phlex::Rails::Helpers::Request
  include Phlex::Rails::Helpers::LinkTo

  CURRENT_ITEM_CLASS = "border-indigo-500 text-indigo-600 whitespace-nowrap border-b-2 py-4 px-1 text-sm font-medium"
  OTHER_ITEM_CLASS = "border-transparent text-gray-500 hover:border-gray-300 hover:text-gray-700 whitespace-nowrap border-b-2 py-4 px-1 text-sm font-medium"

  def view_template(&)
    div(class: "border-b border-gray-200") do
      nav(class: "-mb-px flex space-x-8", aria_label: "Tabs", &)
    end
  end

  def item(url, &)
    a(
      href: url,
      class: current_path?(url) ? CURRENT_ITEM_CLASS : OTHER_ITEM_CLASS,
      &
      )
  end

  def current_path?(path)
    request.path.starts_with? path
  end
end
