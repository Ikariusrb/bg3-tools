class ItemsController < ApplicationController
    layout -> { ApplicationLayout }

  def index
    render View::Items::Index.new(
      items: Item.all.load_async
    )
  end

  def show
    render Items::Show.new(
      item: Item.find(params[:id])
    )
  end

  def edit
    render Items::Edit.new(
      item: Item.find(params[:id])
    )
  end

  def create
  end

  def update
    binding.pry
  end

  def destroy
  end
end
