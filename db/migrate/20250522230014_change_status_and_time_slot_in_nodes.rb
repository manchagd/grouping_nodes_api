class ChangeStatusAndTimeSlotInNodes < ActiveRecord::Migration[7.2]
  def change
    change_column :nodes, :status, :string
    change_column :nodes, :time_slot, :string
  end
end
