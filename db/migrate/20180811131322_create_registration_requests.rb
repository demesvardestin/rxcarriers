class CreateRegistrationRequests < ActiveRecord::Migration
  def change
    create_table :registration_requests do |t|
      t.string :pharmacy_name
      t.string :pharmacy_email
      t.string :pharmacy_phone
      t.string :pharmacy_address
      t.string :pharmacy_manager
      t.string :pharmacy_website
      t.string :secure_token
      t.boolean :approved, default: false
      t.datetime :approved_on
      t.datetime :denied_on

      t.timestamps null: false
    end
  end
end
