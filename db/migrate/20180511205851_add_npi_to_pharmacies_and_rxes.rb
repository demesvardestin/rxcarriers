class AddNpiToPharmaciesAndRxes < ActiveRecord::Migration
  def change
    add_column :pharmacies, :npi, :string
    add_column :rxes, :npi, :string
  end
end
