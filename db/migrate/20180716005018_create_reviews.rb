class CreateReviews < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
      t.string :content
      t.integer :pharmacy_id
      t.boolean :flagged

      t.timestamps null: false
    end
  end
end
