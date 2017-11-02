class AddMoreDetailsToRequestAndCancellationMessages < ActiveRecord::Migration
  def change
    add_column :request_messages, :driver, :string
    add_column :cancellation_messages, :request_type, :string
  end
end
