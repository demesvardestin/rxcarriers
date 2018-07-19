class CreateBatches < ActiveRecord::Migration
  def change
    create_table :batches do |t|
      
      t.timestamps null: false
      t.string :name
    end
  end
end

