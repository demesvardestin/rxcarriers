class AddMoreHoursToPharmacies < ActiveRecord::Migration
  def change
    add_column :pharmacies, :opening_weekday, :string
    add_column :pharmacies, :closing_weekday, :string
    add_column :pharmacies, :opening_saturday, :string
    add_column :pharmacies, :closing_saturday, :string
    add_column :pharmacies, :opening_sunday, :string
    add_column :pharmacies, :closing_sunday, :string
  end
end
