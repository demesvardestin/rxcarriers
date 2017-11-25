class AddCopayToDeliveries < ActiveRecord::Migration
  def change
    add_column :deliveries, :copay, :string
  end
end
