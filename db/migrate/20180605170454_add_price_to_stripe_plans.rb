class AddPriceToStripePlans < ActiveRecord::Migration
  def change
    add_column :stripe_plans, :price, :string
  end
end
