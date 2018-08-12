class AddNdcToItems < ActiveRecord::Migration
  def change
    add_column :items, :ndc, :string
  end
end
