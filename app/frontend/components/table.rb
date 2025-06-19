# frozen_string_literal: true

class Components::Table < Components::Base
  DEFAULT_TABLE_CLASSES = "min-w-full divide-y divide-gray-200 dark:divide-gray-700"
  DEFAULT_THEAD_CLASSES = "bg-gray-50 dark:bg-slate-700"
  DEFAULT_TBODY_CLASSES = "bg-white dark:bg-slate-800"
  DEFAULT_TH_CLASSES = "px-6 py-3 text-left text-xs font-semibold text-gray-500 dark:text-gray-200 uppercase tracking-wider"
  DEFAULT_TR_CLASSES = "even:bg-slate-800 odd:bg-slate-600"
  DEFAULT_TD_CLASSES = "border-b border-slate-400 whitespace-nowrap p-2 text-sm text-gray-350 dark:text-gray-350"

  def initialize(rows)
    @rows = rows
    @columns = []
  end

  def view_template(&)
    vanish(&)

    div(class: "border rounded-lg overflow-hidden my-8") do
      table(class: DEFAULT_TABLE_CLASSES) do
        thead(class: DEFAULT_THEAD_CLASSES) do
          @columns.each do |column|
            th(class: DEFAULT_TH_CLASSES) { column[:header] }
          end
        end

        tbody(class: DEFAULT_TBODY_CLASSES) do
          @rows.each do |row|
            tr(class: DEFAULT_TR_CLASSES) do
              @columns.each do |column|
                td(class: DEFAULT_TD_CLASSES) { column[:content].call(row) }
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
