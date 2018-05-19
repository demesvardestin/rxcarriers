class CreateRxes < ActiveRecord::Migration
  def change
    create_table :rxes do |t|

      t.timestamps null: false
    end
  end
end
