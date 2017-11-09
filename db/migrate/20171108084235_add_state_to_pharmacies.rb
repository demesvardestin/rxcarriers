class AddStateToPharmacies < ActiveRecord::Migration
  def change
    add_column :pharmacies, :state, :string
  end
end
