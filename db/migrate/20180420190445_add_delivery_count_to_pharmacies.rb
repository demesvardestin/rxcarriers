class AddDeliveryCountToPharmacies < ActiveRecord::Migration
  def change
    add_column :pharmacies, :deliveries_today, :integer
    add_column :deliveries, :deleted, :boolean
    # add_column :batches, :deleted, :boolean
  end
end
