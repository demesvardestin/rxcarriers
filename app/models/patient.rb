class Patient < ActiveRecord::Base
    
    belongs_to :patable, :polymorphic => true
    belongs_to :pharmacy
    
    geocoded_by :address
    after_validation :geocode
end
