class ItemsController < ApplicationController
    layout -> { ApplicationLayout }

  def index
    render Items::IndexView.new(
      items: Item.all.load_async
    )
  end

  def show
    render Items::ShowView.new(
      item: Item.find(params[:id])
    )
  end
end
