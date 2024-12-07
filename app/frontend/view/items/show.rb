# /home/rbecker/code/bg3-tools/app/views/items/show.rb

class View::Items::Show < Phlex::HTML
  attr_reader :item

  def initialize(item:)
    @item = item
  end

  def view_template
    h1 { @item.name }
    p { @item.description }
    ul do
      @item.attributes.each do |key, value|
        li { "#{key}: #{value}" }
      end
    end
  end
end
