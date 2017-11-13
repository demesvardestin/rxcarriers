class AddStripeDetailsToPharmacies < ActiveRecord::Migration
  def change
    add_column :pharmacies, :uid, :string
    add_column :pharmacies, :token, :string
    add_column :pharmacies, :provider, :string
  end
end
