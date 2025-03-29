class AdditionalItemProperties < ActiveRecord::Migration[8.0]
  def change
    add_column :items, :location, :string
    add_column :items, :act, :string
    add_column :items, :rarity, :string
    add_column :items, :item_type, :string
    add_column :items, :price, :string
    add_column :items, :weight, :string
    add_column :items, :effects, :string
  end
end
