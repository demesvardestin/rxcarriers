class AddHoursDetailsToPharmacies < ActiveRecord::Migration
  def change
    add_column :pharmacies, :hours, :string
    add_column :pharmacies, :delivers, :string
  end
end
