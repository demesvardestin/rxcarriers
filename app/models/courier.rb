class Courier < ActiveRecord::Base
    
    def bank_token_present?
        self.bank_token.nil? ? 'false' : 'true' 
    end
    
    def onboarding_step?
        case self.onboarding_step
            when '1'
                return 'address'
            when '2'
                return 'agreements'
        end
    end
    
    def self.fetch(req)
        Courier.where(on_duty: false).each do |c|
            
        end
    end
end
