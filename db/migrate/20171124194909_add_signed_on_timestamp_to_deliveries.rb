class AddSignedOnTimestampToDeliveries < ActiveRecord::Migration
  def change
    add_column :deliveries, :signed_on, :datetime
  end
end
