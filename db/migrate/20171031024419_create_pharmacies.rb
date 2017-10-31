class CreatePharmacies < ActiveRecord::Migration
  def change
    create_table :pharmacies do |t|

      t.timestamps null: false
    end
  end
end
