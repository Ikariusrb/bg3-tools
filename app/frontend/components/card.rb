# frozen_string_literal: true

class Components::Card < Components::Base
  def initialize(title:)
    @title = title
  end

  def view_template
    div(class: "border divide-y divide-gray-200 overflow-hidden rounded-lg shadow") do
      div(class: "px-4 py-5 sm:px-6 dark:bg-slate-850") do
        h3(class: "card-title") { @title }
      end
      div(class: "px-4 py-5 sm:p-6 dark:bg-slate-800") do
        whitespace
        yield
      end
    end
  end
end
