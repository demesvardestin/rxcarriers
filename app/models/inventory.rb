class Inventory < ActiveRecord::Base
    has_many :items
    has_many :item_categories
    belongs_to :pharmacy
end
