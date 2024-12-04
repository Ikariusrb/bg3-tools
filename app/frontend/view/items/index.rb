# frozen_string_literal: true

class View::Items::Index < ApplicationView
  include Phlex::Rails::Helpers::LinkTo
  include Phlex::Rails::Helpers::Routes

  attr_reader :notice

  def initialize(items:, notice: nil)
    @items = items
    @notice = notice
  end

  def view_template
    p(style: "color:#008000") { notice }

    div(class: "flex flex-row place-content-center") do
      div(id: "auto_tags", class: "relative overflow-auto basis-11/12") do
        div(class: "border rounded-lg overflow-hidden my-8") do
          table(class: "border-collapse table-auto w-full text-sm") do
            thead(class: "dark:bg-slate-850") do
              div(class: "pt-2") do
                tr do
                  [ "Name", "Description", "UUID", "Actions" ].each do |header|
                    th(
                      class:
                        "border-b font-semibold p-4 pt-0 pb-3 text-slate-400 dark:text-slate-200 text-left"
                    ) { header }
                  end
                end
              end
            end
            tbody(class: "bg-white dark:bg-slate-800") do
              whitespace
              @items.each do |item|
                whitespace
                render View::Items::Row.new(item: item)
                whitespace
              end
            end
          end
        end
      end
    end

    # div(class: "flex flex-row basis-11/12") do
    #   div(
    #     data_controller: "rest-action",
    #     data_rest_multi_url: auto_tags_action_path,
    #     data_rest_action_target: "container",
    #     class: "flex"
    #   ) do
    #     whitespace
    #     link_to "New",
    #             new_item_path,
    #             class:
    #               "bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded focus:outline-none focus:shadow-outline"
    #     whitespace
    #     button(
    #       data_action: " click->rest-action#multiAction",
    #       data_rest_action_action_param: "apply_all",
    #       class:
    #         "bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded focus:outline-none focus:shadow-outline"
    #     ) { "Apply All" }
    #     plain " Apply All "
    #   end
    # end
  end
end
