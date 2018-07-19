class AddTrackingUrlToBatches < ActiveRecord::Migration
  def change
    add_column :batches, :tracking_url, :string
    add_column :batches, :status, :string
  end
end
