class CreateCategories < ActiveRecord::Migration[7.2]
  def change
    create_table :categories do |t|
      t.string :name, null: false
      t.integer :parent_id

      t.timestamps
    end
    add_index :categories, :parent_id
    add_foreign_key :categories, :categories, column: :parent_id
  end
end