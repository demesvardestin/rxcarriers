class AddDriverRequestStateToDrivers < ActiveRecord::Migration
  def change
    add_column :drivers, :requested, :boolean
    # add_column :request_messages, 
  end
end
