class AddWebsitesToPharmacies < ActiveRecord::Migration
  def change
    add_column :pharmacies, :website, :string
  end
end
