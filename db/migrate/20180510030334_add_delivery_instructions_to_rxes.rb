class AddDeliveryInstructionsToRxes < ActiveRecord::Migration
  def change
    add_column :rxes, :delivery_instructions, :string
  end
end
