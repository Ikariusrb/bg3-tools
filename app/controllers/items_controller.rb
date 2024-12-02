class ItemsController < ApplicationController
    layout -> { ApplicationLayout }

  def index
    render Items::IndexView.new(
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
  end

  def destroy
  end
end
