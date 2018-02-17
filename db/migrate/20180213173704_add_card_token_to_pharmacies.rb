class AddCardTokenToPharmacies < ActiveRecord::Migration
  def change
    add_column :pharmacies, :card_token, :string
  end
end
