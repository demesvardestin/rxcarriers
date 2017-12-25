class AddCreditCardDetailsToPharmacies < ActiveRecord::Migration
  def change
    add_column :pharmacies, :card_number, :string
    add_column :pharmacies, :exp_year, :integer
    add_column :pharmacies, :exp_month, :integer
    add_column :pharmacies, :bill_street, :string
    add_column :pharmacies, :bill_city, :string
    add_column :pharmacies, :bill_state, :string
    add_column :pharmacies, :bill_zip, :string
    add_column :pharmacies, :bill_country, :string
    add_column :pharmacies, :cvc, :string
  end
end
