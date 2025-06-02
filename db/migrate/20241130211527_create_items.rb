# frozen_string_literal: true

class CreateItems < ActiveRecord::Migration[8.0]
  def change
    create_table :items do |t|
      t.string :name
      t.string :description
      t.string :uuid

      t.timestamps
    end
  end
end
