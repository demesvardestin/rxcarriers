class AddPaymentDetailsToPharmacy < ActiveRecord::Migration
  def change
    add_column :pharmacies, :stripe_connected, :boolean
    add_column :pharmacies, :stripe_cus, :string
  end
end
