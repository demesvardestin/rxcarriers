class AddMatrixToDeliveries < ActiveRecord::Migration
  def change
    add_column :deliveries, :matrix, :string
  end
end
