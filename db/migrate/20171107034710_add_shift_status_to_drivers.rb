class AddShiftStatusToDrivers < ActiveRecord::Migration
  def change
    add_column :drivers, :clocked_in, :boolean
  end
end
