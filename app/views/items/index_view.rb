# frozen_string_literal: true

class Items::IndexView < ApplicationView
  def initialize(items:)
    @items = items
  end

  private
  def view_template
    h1 { "Items::Index" }
    p { "Find me in app/views/items/index_view.rb" }
  end
end
