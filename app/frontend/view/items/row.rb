

class View::Items::Row < Phlex::HTML
  include Phlex::Rails::Helpers::DOMID
  include Phlex::Rails::Helpers::LinkTo
  include Phlex::Rails::Helpers::Routes
  register_value_helper :heroicon

  attr_reader :item

  def initialize(item:)
    @item = item
  end

  def view_template
    div(id: (dom_id item), class: "flex") do
      tr(class: "even:bg-slate-800 odd:bg-slate-600") do
        td(class: "border-b border-slate-400 p-2 font-medium") do
          whitespace
          plain item.name
        end
        td(class: "border-b border-slate-400 p-2 font-medium") do
          whitespace
          plain item.description
        end
        td(class: "border-b border-slate-400 p-2 font-medium") do
          whitespace
          plain item.uuid
        end
        td(class: "border-b border-slate-400 p-2 font-medium") do
          link_to(item) do
            span(class: "svg-image") do
              heroicon("eye", variant: :mini)
            end
            whitespace
          end
          whitespace
          link_to(edit_item_path(item)) do
            span(class: "svg-image") do
              heroicon("pencil", variant: :mini)
            end
            whitespace
          end
          whitespace
          link_to(
            item_path(item),
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
end
