class ItemsController < ResourceController
    layout -> { ApplicationLayout }

  def index
    render View::Items::Index.new(
      items: Item.all.load_async
    )
  end

  def show
    render View::Items::Show.new(
      item: Item.find(params[:id])
    )
  end

  def new
    render View::Items::Edit.new(item: Item.new, notice: notice)
  end

  def edit
    render View::Items::Edit.new(item: Item.find(params[:id]))
  end

  def create
  end

  def update
    item = Item.find_by!(id: params[:id])
    item.update!(item_params)
    redirect_to item_url(item), notice: "Item was successfully updated."
  end

  def destroy
  end

  private

  def item_params
    params.require(:item).permit(:name, :description, :uuid)
  end
end
