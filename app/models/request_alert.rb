class RequestAlert < ActiveRecord::Base
    require 'color'
    
    def type
        'refill'
    end
    
    def get_rx
        rx = self.rx
        return Rx.find_by(rx: rx)
    end
    
end
