class View::Items::Edit < Phlex::HTML
  include Phlex::Rails::Helpers::FormFor
  include Phlex::Rails::Helpers::LinkTo

  attr_reader :item

  def initialize(item:)
    @item = item
  end

  def template
    form_for item do |f|
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
        link_to("Cancel", :back)
      end
    end
  end
end
