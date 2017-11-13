class AddPharmacistSignatureToBatches < ActiveRecord::Migration
  def change
    add_column :batches, :pharmacist, :string
  end
end
