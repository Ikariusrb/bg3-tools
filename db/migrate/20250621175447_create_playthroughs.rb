# frozen_string_literal: true

class CreatePlaythroughs < ActiveRecord::Migration[8.0]
  def change
    create_table :playthroughs do |t|
      t.string :name
      t.string :description

      t.timestamps
    end
  end
end
