class ItemsController < ResourceController
    layout -> { ApplicationLayout }

  def index
    render View::Items::Index.new(
      items: Item.all.load_async,
      notice: notice
    )
  end

  def show
    render View::Items::Show.new(
      item: Item.find(params[:id]),
      notice: notice
    )
  end

  def new
    render View::Items::Edit.new(item: Item.new, action: :new, notice: notice)
  end

  def edit
    render View::Items::Edit.new(item: Item.find(params[:id]), action: :edit, notice: notice)
  end

  def create
    new_item = Item.new(item_params)
    new_item.save!
    redirect_to item_url(new_item), notice: "Item was successfully created"
  rescue ActiveRecord::RecordInvalid => e
    render View::Items::Edit.new(item: new_item)
  end

  def update
    item = Item.find_by!(id: params[:id])
    item.update!(item_params)
    redirect_to item_url(item), notice: "Item was successfully updated"
  end

  def destroy
    item = Item.find_by!(id: params[:id])
    item.destroy!
    redirect_to items_url, notice: "Item was successfully deleted"
  rescue ActiveRecord::RecordNotDestroyed => e
    redirect_to items_url, notice: "Item could not be deleted: #{e.message}"
  end

  private

  def item_params
    params.require(:item).permit(:name, :description, :uuid)
  end
end
