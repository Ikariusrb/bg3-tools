class CreateBuildItems < ActiveRecord::Migration[8.0]
  def change
    create_table :build_items do |t|
      t.references :build, null: false, foreign_key: true
      t.references :item, null: false, foreign_key: true

      t.timestamps
    end
  end
end
