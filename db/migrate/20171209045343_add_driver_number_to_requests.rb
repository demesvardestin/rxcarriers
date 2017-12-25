class AddDriverNumberToRequests < ActiveRecord::Migration
  def change
    add_column :requests, :driver_number, :string
  end
end
