class AddPharmacyIdToBatches < ActiveRecord::Migration
  def change
    add_column :batches, :pharmacy_id, :integer
    add_column :batches, :deleted, :boolean
  end
end
