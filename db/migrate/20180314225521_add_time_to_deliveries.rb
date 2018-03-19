class AddTimeToDeliveries < ActiveRecord::Migration
  def change
    add_column :deliveries, :duration, :string
  end
end
