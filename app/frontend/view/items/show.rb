# /home/rbecker/code/bg3-tools/app/views/items/show.rb

class View::Items::Show < Phlex::HTML
  include Phlex::Rails::Helpers::LinkTo
  include Phlex::Rails::Helpers::Routes
  include Phlex::Rails::Helpers::Routes

  attr_reader :item, :notice

  def initialize(item, notice: nil)
    @item = item
    @notice = notice
  end

  def view_template
    p(style: "color:#008000") { notice }
    h1 { @item.name }
    p { @item.description }
    ul do
      @item.attributes.each do |key, value|
        li { "#{key}: #{value}" }
      end
    end
    link_to "All Items",
            items_path,
            class:
              "bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded focus:outline-none focus:shadow-outline"
  end
end
