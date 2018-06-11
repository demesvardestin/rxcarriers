class StripePlan < ActiveRecord::Base
    
    def get_price
        plan = self.name
        case plan
        when 'beginner'
            "99.99"
        when 'pro'
            "129.99"
        end
    end
    
    def self.get_for(id)
        return StripePlan.find_by(pharmacy_id: id) 
    end
end
