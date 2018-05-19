class AddDeliveryRequestedToRxes < ActiveRecord::Migration
  def change
    add_column :rxes, :delivery_requested, :boolean
  end
end
