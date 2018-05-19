class Rx < ActiveRecord::Base
    
    has_many :delivery_requests
    
    def self.search(param)
        param.strip!
        param.downcase!
        (rx_matches(param) + address_matches(param) + phone_matches(param)).uniq
    end
    
    def self.rx_matches(param)
        matches('rx', param)
    end
    
    def self.address_matches(param)
        matches('address', param)
    end
    
    def self.phone_matches(param)
        matches('phone_number', param)
    end
    
    def self.matches(field_name, param)
        where("lower(#{field_name}) like ?", "%#{param}%")
    end
    
    def filled
        return self.current_status == 'refilled' 
    end
    
    def not_ready
        return self.current_status == 'delivered' || self.current_status == 'picked' 
    end
    
    def issue_present
        return self.current_status == 'inactive' 
    end
    
    def delivery_requested
        return self.delivery_requested == true 
    end
    
    def get_delivery_details
        rx = self.rx
        return DeliveryRequest.find_by(rx: rx)
    end
    
    def object?
        return self.is_a?(Rx) 
    end
    
end
