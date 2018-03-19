class AddDeliveryDetailsToBatch < ActiveRecord::Migration
  def change
    add_column :batches, :request_mileage, :string
    add_column :batches, :request_cost, :string
    add_column :batches, :delivery_duration, :string
  end
end
