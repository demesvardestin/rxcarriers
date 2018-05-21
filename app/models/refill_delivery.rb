class RefillDelivery < ActiveRecord::Base
    require 'color'
    
    def type
        'refill + delivery'
    end
    
end
