class AddMoreHoursOptionsToPharmacies < ActiveRecord::Migration
  def change
    add_column :pharmacies, :saturday, :string
    add_column :pharmacies, :sunday, :string
  end
end
