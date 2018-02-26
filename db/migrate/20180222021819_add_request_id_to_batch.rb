class AddRequestIdToBatch < ActiveRecord::Migration
  def change
    add_column :batches, :request_id, :string
  end
end
