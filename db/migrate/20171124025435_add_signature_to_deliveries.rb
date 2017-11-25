class AddSignatureToDeliveries < ActiveRecord::Migration
  def change
    add_column :deliveries, :signature, :string
  end
end
