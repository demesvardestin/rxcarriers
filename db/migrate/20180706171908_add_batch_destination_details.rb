class AddBatchDestinationDetails < ActiveRecord::Migration
  def change
    add_column :batches, :address, :string
    add_column :batches, :phone_number, :string
  end
end
