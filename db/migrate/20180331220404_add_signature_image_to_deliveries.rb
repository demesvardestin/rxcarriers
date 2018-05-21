class AddSignatureImageToDeliveries < ActiveRecord::Migration
  def change
    add_column :deliveries, :signature_image, :text
    add_column :deliveries, :request_sent_on, :datetime
    # add_column :batches, :deliveries_completed, :integer
  end
end
