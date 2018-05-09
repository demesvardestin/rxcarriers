class AddRequestDetailsToBatches < ActiveRecord::Migration
  def change
    add_column :batches, :cancelled, :boolean
  end
end
