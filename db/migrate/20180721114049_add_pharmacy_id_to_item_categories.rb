class AddPharmacyIdToItemCategories < ActiveRecord::Migration
  def change
    add_column :item_categories, :pharmacy_id, :integer
  end
end
