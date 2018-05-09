class AddCidToCouriers < ActiveRecord::Migration
  def change
    add_column :couriers, :cid, :string
  end
end
