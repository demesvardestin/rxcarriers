class AddAutoIdToBatches < ActiveRecord::Migration
  def change
    add_column :batches, :auto_id, :string
  end
end
