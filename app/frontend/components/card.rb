# frozen_string_literal: true

class Components::Card < Components::Base
  include CSSMerging

  CARD_BORDER_DEFAULT_CSS = "border divide-y divide-gray-200 overflow-hidden rounded-lg shadow dark:bg-slate-850 dark:divide-slate-700"
  CARD_TITLE_FRAME_DEFAULT_CSS = "px-4 py-5 sm:px-6 dark:bg-slate-850"
  CARD_BODY_DEFAULT_CSS = "px-4 py-5 sm:p-6 dark:bg-slate-800"

  def initialize(title:, css: {})
    @title = title
    @css = css
  end

  def view_template
    div(class: merged_css(:card_border)) do
      div(class: merged_css(:card_title_frame)) do
        h3(class: "card-title") { @title }
      end
      div(class: merged_css(:card_body)) do
        whitespace
        yield
      end
    end
  end
end
