class AddActiveStatusToItems < ActiveRecord::Migration
  def change
    add_column :items, :active, :boolean, default: true
    add_column :items, :can_be_taxed, :string
  end
end
