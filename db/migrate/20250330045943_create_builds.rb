class CreateBuilds < ActiveRecord::Migration[8.0]
  def change
    create_table :builds do |t|
      t.string :name
      t.string :description

      t.timestamps
    end
  end
end
