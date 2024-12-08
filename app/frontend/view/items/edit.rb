class View::Items::Edit < Phlex::HTML
  include Phlex::Rails::Helpers::FormFor
  include Phlex::Rails::Helpers::LinkTo
  include Phlex::Rails::Helpers::Routes

  attr_reader :item, :action, :notice

  def initialize(item, action:, notice: nil)
    @item = item
    @action = action
    @notice = notice
  end

  def view_template
    form_for(item) do |f|
      div do
        f.label :name
        f.text_field :name
      end

      div do
        f.label :description
        f.text_area :description
      end

      div do
        f.label :uuid
        f.text_field :uuid
      end

      div do
        f.submit("Save", class: "bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded focus:outline-none focus:shadow-outline")
        if action == :new
          link_to("Cancel", items_path)
        else
          link_to("Cancel", item)
        end
      end
    end
  end
end
