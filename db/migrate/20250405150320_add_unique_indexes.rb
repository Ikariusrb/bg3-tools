# frozen_string_literal: true

class AddUniqueIndexes < ActiveRecord::Migration[8.0]
  def change
    add_index :build_items, [ :item_id, :build_id ], unique: true
    add_index :items, [ :name ], unique: true
    add_index :builds, [ :name ], unique: true
  end
end
