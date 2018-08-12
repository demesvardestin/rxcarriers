class Refund < ActiveRecord::Base
    belongs_to :order
    belongs_to :pharmacy
end
