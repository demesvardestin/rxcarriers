class AddDetailsToCouriers < ActiveRecord::Migration
  def change
    add_column :couriers, :name, :string
    add_column :couriers, :email, :string
    add_column :couriers, :number, :string
    add_column :couriers, :address, :string
    add_column :couriers, :firebase_uid, :string
    add_column :couriers, :bank_token, :string
    add_column :couriers, :stripe_cus, :string
    add_column :couriers, :car_color, :string
    add_column :couriers, :car_make, :string
    add_column :couriers, :car_year, :string
    add_column :couriers, :car_model, :string
    add_column :couriers, :license_plate, :string
    add_column :deliveries, :driver_id, :string
    add_column :batches, :driver_id, :string
  end
end
