class ChangeNullConstraintsOnNodes < ActiveRecord::Migration[7.2]
  def change
    change_column_null :nodes, :number, true
    change_column_null :nodes, :plate, true
    change_column_null :nodes, :reference_code, true
    change_column_null :nodes, :relative_age, true
    change_column_null :nodes, :seal, true
    change_column_null :nodes, :serie, true
    change_column_null :nodes, :size, true
    change_column_null :nodes, :status, true
    change_column_null :nodes, :time_slot, true
  end
end
