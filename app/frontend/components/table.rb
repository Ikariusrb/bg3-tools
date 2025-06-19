# frozen_string_literal: true

class Components::Table < Components::Base
  include CSSMerging

  TABLE_DEFAULT_CSS = "min-w-full divide-y divide-gray-200 dark:divide-gray-700"
  THEAD_DEFAULT_CSS = "bg-gray-50 dark:bg-slate-700"
  TBODY_DEFAULT_CSS = "bg-white dark:bg-slate-800"
  TH_DEFAULT_CSS = "px-6 py-3 text-left text-xs font-semibold text-gray-500 dark:text-gray-200 uppercase tracking-wider"
  TR_DEFAULT_CSS = "even:bg-slate-800 odd:bg-slate-600"
  TD_DEFAULT_CSS = "border-b border-slate-400 whitespace-nowrap p-2 text-sm text-gray-350 dark:text-gray-350"

  attr_reader :rows, :columns, :css

  def initialize(rows, css: {})
    @rows = rows
    @columns = []
    @css = css
  end

  def view_template(&)
    vanish(&)

    div(class: "border rounded-lg overflow-hidden my-8") do
      table(class: merged_css(:table)) do
        thead(class: merged_css(:thead)) do
          columns.each do |column|
            th(class: merged_css(:th)) { column[:header] }
          end
        end

        tbody(class: merged_css(:tbody)) do
          rows.each do |row|
            tr(class: merged_css(:tr)) do
              columns.each do |column|
                td(class: merged_css(:td)) { column[:content].call(row) }
              end
            end
          end
        end
      end
    end
  end

  def column(header, &content)
    @columns << { header:, content: }
    nil
  end
end
