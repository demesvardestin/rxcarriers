class CreateDeliveryHours < ActiveRecord::Migration
  def change
    create_table :delivery_hours do |t|
      t.string :monday
      t.string :tuesday
      t.string :wednesday
      t.string :thursday
      t.string :friday
      t.string :saturday
      t.string :sunday
      t.integer :pharmacy_id

      t.timestamps null: false
    end
  end
end
