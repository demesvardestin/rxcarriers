class AddPackageObjectToBatches < ActiveRecord::Migration
  def change
    add_column :batches, :packages, :object
  end
end
