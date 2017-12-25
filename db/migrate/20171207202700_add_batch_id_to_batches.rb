class AddBatchIdToBatches < ActiveRecord::Migration
  def change
    add_column :batches, :batch_id, :integer
  end
end
