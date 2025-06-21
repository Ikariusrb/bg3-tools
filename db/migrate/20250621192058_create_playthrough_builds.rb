# frozen_string_literal: true

class CreatePlaythroughBuilds < ActiveRecord::Migration[8.0]
  def change
    create_table :playthrough_builds do |t|
      t.references :playthrough, null: false, foreign_key: true
      t.string :companion
      t.references :build, null: false, foreign_key: true

      t.timestamps
    end
  end
end
