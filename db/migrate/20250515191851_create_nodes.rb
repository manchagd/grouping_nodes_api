class CreateNodes < ActiveRecord::Migration[7.2]
  def change
    create_table :nodes do |t|
      t.string :name, null: false
      t.string :seal, null: false, limit: 3
      t.string :serie, null: false, limit: 3
      t.string :plate, null: false
      t.integer :status, null: false
      t.integer :number, null: false
      t.float :size, null: false
      t.uuid :reference_code, null: false
      t.text :description
      t.integer :time_slot, null: false
      t.integer :relative_age, null: false
      t.references :category, null: false, foreign_key: true

      t.timestamps
    end

    add_index :nodes, :plate, unique: true
    add_index :nodes, :reference_code, unique: true
  end
end
