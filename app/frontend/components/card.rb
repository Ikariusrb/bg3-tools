# frozen_string_literal: true

class Components::Card < Components::Base
  CARD_CSS = %w[border divide-y divide-gray-200 overflow-hidden rounded-lg shadow dark:bg-slate-850 dark:divide-slate-700].freeze

  def initialize(title:, extra_css: [])
    @title = title
    @extra_css = extra_css
  end

  def view_template
    div(class: (CARD_CSS + @extra_css).join(' ')) do
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
