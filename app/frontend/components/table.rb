# frozen_string_literal: true

class Components::Table < Components::Base
  def initialize(rows)
    @rows = rows
    @columns = []
  end

  def view_template(&)
    vanish(&)

    table(class: "min-w-full divide-y divide-gray-200 dark:divide-gray-700") do
      thead(class: "bg-gray-50 dark:bg-slate-700") do
        @columns.each do |column|
          th(class: "px-6 py-3 text-left text-xs font-medium text-gray-500 dark:text-gray-200 uppercase tracking-wider") { column[:header] }
        end
      end

      tbody do
        @rows.each do |row|
          tr do
            @columns.each do |column|
              td(class: "px-6 py-4 whitespace-nowrap text-sm text-gray-500 dark:text-gray-300") { column[:content].call(row) }
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
