class AddLatitudeLongitudeToPharmacies < ActiveRecord::Migration
  def change
    add_column :pharmacies, :latitude, :float
    add_column :pharmacies, :longitude, :float
  end
end
