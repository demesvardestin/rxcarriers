class AddPreferredTimeToDeliveries < ActiveRecord::Migration
  def change
    add_column :deliveries, :time, :string
  end
end
