class AddRefillRequestedToRxes < ActiveRecord::Migration
  def change
    add_column :rxes, :refill_requested, :boolean
  end
end
