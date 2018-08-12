class ItemCategory < ActiveRecord::Base
    belongs_to :pharmacy
    belongs_to :inventory
    has_many :items
end
