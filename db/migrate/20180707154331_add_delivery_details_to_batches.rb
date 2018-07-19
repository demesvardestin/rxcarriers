class AddDeliveryDetailsToBatches < ActiveRecord::Migration
  def change
    add_column :batches, :quote_id, :string
    add_column :batches, :quote_price, :integer
    add_column :batches, :courier_name, :string
    add_column :batches, :courier_rating, :string
    add_column :batches, :courier_vehicle_type, :string
    add_column :batches, :courier_phone_number, :string
    add_column :batches, :courier_avatar, :string
    add_column :batches, :delivery_id, :string
  end
end
