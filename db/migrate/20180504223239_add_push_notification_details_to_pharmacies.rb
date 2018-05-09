class AddPushNotificationDetailsToPharmacies < ActiveRecord::Migration
  def change
    add_column :pharmacies, :subscribed_to_push, :boolean
    add_column :pharmacies, :push_endpoint, :string
    add_column :pharmacies, :sub_auth, :string
    add_column :pharmacies, :p256dh, :string
  end
end
