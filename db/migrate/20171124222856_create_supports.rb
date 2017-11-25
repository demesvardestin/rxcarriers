class CreateSupports < ActiveRecord::Migration
  def change
    create_table :supports do |t|

      t.timestamps null: false
    end
  end
end
