# frozen_string_literal: true

class View::Resource::Index < ApplicationView
  include Phlex::Rails::Helpers::LinkTo
  include Phlex::Rails::Helpers::Routes
  include Phlex::Rails::Helpers::URLFor
  include Phlex::Rails::Helpers::ControllerName
  include Phlex::Rails::Helpers::DOMID
  register_value_helper :heroicon
  register_value_helper :polymorphic_url

  attr_reader :resources, :notice

  def initialize(resources, notice: nil)
    @resources = resources
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
                  [ *index_columns.map(&:capitalize), "Actions" ].each do |header|
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
              resources.each do |resource|
                whitespace
                row_template(resource)
                whitespace
              end
            end
          end
        end
      end
    end

    div(class: "flex flex-row basis-11/12") do
      link_to "New",
              url_for(action: :new),
              class:
                "bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded focus:outline-none focus:shadow-outline"
    end
  end

  def row_template(resource)
    div(id: (dom_id resource), class: "flex") do
      tr(class: "even:bg-slate-800 odd:bg-slate-600") do
        index_columns.each do |column|
          td(class: "border-b border-slate-400 p-2 font-medium") do
            whitespace
            plain resource.public_send(column)
          end
        end
        td(class: "border-b border-slate-400 p-2 font-medium") do
          link_to(resource) do
            span(class: "svg-image") do
              heroicon("eye", variant: :mini)
            end
            whitespace
          end
          whitespace
          link_to(polymorphic_url(resource, action: :edit)) do
            span(class: "svg-image") do
              heroicon("pencil", variant: :mini)
            end
            whitespace
          end
          whitespace
          link_to(
            url_for(resource),
            data: {
              turbo_method: :delete,
              turbo_confirm: "Are you certain you want to delete this?"
            }
          ) do
            span(class: "svg-image") do
              heroicon("trash", variant: :mini)
            end
            whitespace
          end
        end
      end
    end
  end
  private

  def index_columns
    @index_columns ||= "#{controller_name.capitalize}Controller::INDEX_COLUMNS".constantize
  end
end
