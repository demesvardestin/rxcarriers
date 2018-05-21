class RequestAlert < ActiveRecord::Base
    require 'color'
    
    def type
        'refill'
    end
    
end
