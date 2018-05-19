class AddRxToDeliveries < ActiveRecord::Migration
  def change
    add_column :deliveries, :rx, :string
  end
end
