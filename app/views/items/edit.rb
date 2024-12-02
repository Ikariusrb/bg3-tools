class Items::Edit < Phlex::HTML
  include Phlex::Rails::Helpers::FormFor

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
        f.submit "Update Item"
      end
    end
  end
end
