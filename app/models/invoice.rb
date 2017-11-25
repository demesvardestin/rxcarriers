class Invoice < ActiveRecord::Base
    
    scope :today, -> { where("date_trunc('day',created_at) = date_trunc('day',now())") }
    
end
