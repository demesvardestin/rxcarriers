class AddFirebaseUidToDrivers < ActiveRecord::Migration
  def change
    add_column :drivers, :firebase_uid, :string
    add_column :drivers, :address, :string
  end
end
