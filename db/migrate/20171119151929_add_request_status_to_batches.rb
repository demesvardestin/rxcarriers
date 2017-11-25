class AddRequestStatusToBatches < ActiveRecord::Migration
  def change
    add_column :batches, :request_status, :string
  end
end
