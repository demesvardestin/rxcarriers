class AddDetailsToDeliveries < ActiveRecord::Migration
  def change
    add_column :deliveries, :deliverable_type, :string
    add_column :deliveries, :deliverable_id, :integer
    add_column :deliveries, :recipient_name, :string
    add_column :deliveries, :recipient_phone_number, :string
    add_column :deliveries, :recipient_address, :string
    add_column :deliveries, :medications, :string
    add_column :deliveries, :pharmacy_id, :integer
    add_index :deliveries, [:deliverable_type, :deliverable_id]
  end
end
