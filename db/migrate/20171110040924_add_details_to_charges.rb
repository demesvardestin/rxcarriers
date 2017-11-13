class AddDetailsToCharges < ActiveRecord::Migration
  def change
    add_column :charges, :description, :string
    add_column :charges, :email, :string
    add_column :charges, :card_token, :string
  end
end
