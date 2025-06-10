# frozen_string_literal: true

class View::Resource::Index < ApplicationView
  include Phlex::Rails::Helpers::LinkTo
  include Phlex::Rails::Helpers::ControllerName
  # include Phlex::Rails::Helpers::DOMID
  register_value_helper :heroicon
  include ResourceNaming
  include Rails.application.routes.url_helpers
  include ActionView::RecordIdentifier

  attr_reader :resources, :notice

  def initialize(resources, notice: nil)
    @resources = resources
    @notice = notice
  end

  def view_template
    p(style: "color:#008000") { notice }

    div(class: "flex flex-row place-content-center") do
      div(id: "auto_tags", class: "relative overflow-auto basis-11/12") do
        render Components::Table.new(resources) do |t|
          index_columns.each do |column|
            t.column(column.capitalize) do |resource|
              div(id: dom_id(resource)) { resource.public_send(column) }
            end
          end
          t.column("Actions") do |resource|
            resource_actions(resource)
          end
        end
      end
    end

    div(class: "flex flex-row basis-11/12") do
      link_to(
        "New",
        url_for(controller: resource_plural.underscore, action: :new, only_path: true),
        class: "bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded focus:outline-none focus:shadow-outline"
      )
    end
  end

  def row_template(resource)
    div(id: (dom_id resource), class: "flex") do
      tr(class: "even:bg-slate-800 odd:bg-slate-600") do
        index_columns.each do |column|
          td(class: "border-b border-slate-400 p-2 font-medium") do
            plain resource.public_send(column)
          end
        end
        td(class: "border-b border-slate-400 p-2 font-medium") do
          resource_actions(resource)
        end
      end
    end
  end

  def resource_actions(resource)
    div(class: "flex flex-row gap-4") do
      link_to(resource, class: 'inline-block') do
        span(class: "svg-image") { heroicon("eye", variant: :mini) }
      end

      link_to(resource_path_for(resource, :edit), class: 'inline-block') do
        span(class: "svg-image") { heroicon("pencil", variant: :mini) }
      end

      link_to(
        resource_path_for(resource, :show),
        data: {
          turbo_method: :delete,
          turbo_confirm: "Are you certain you want to delete this?"
        },
        class: 'inline-block'
      ) do
        span(class: "svg-image") { heroicon("trash", variant: :mini) }
      end
    end
  end

  private

  def resource_path_for(resource, action)
    url_for(controller: resource_plural.underscore, action: action, id: resource.id, only_path: true)
  end

  def index_columns
    @index_columns ||= "#{controller_name.capitalize}Controller::INDEX_COLUMNS".constantize
  end
end
