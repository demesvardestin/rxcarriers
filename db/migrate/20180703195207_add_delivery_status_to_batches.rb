class AddDeliveryStatusToBatches < ActiveRecord::Migration
  def change
    add_column :batches, :delivered, :boolean
    add_column :batches, :requested_at, :datetime
  end
end
