class Invoice < ActiveRecord::Base
    
    # scopes
    scope :today, -> { where("date_trunc('day',created_at) = date_trunc('day',now())") }
    
    # methods
    def self.today
        where("created_at >= ?", Time.zone.now.beginning_of_day)
    end
    
end
