class AddConnectedAccountToRefunds < ActiveRecord::Migration
  def change
    add_column :refunds, :connected_account, :string
  end
end
