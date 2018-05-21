class DeliveryRequest < ActiveRecord::Base
    require 'color'
    
    def type
        'delivery'
    end
    
end
