class AddCourierRequestedToBatches < ActiveRecord::Migration
  def change
    add_column :batches, :courier_requested, :boolean
  end
end
