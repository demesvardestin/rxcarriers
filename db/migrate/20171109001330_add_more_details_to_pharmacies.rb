class AddMoreDetailsToPharmacies < ActiveRecord::Migration
  def change
    add_column :pharmacies, :number, :string
  end
end
