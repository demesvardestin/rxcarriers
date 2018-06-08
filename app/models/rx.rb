class Rx < ActiveRecord::Base
    
    has_many :delivery_requests
    
    # validates_presence_of :rx
    # validates
    
    def self.search(param)
        param.strip!
        param.downcase!
        (rx_matches(param) + address_matches(param) + phone_matches(param) + dob_matches(param)).uniq
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
    
    def self.dob_matches(param)
        matches('dob', param)
    end
    
    def self.matches(field_name, param)
        where("lower(#{field_name}) like ?", "%#{param}%")
    end
    
    def filled
        return self.current_status == 'refilled' 
    end
    
    def delivery_sent
        return self.current_status == 'sent' 
    end
    
    def picked
        return self.current_status == 'picked' 
    end
    
    def not_ready
        return self.current_status == 'delivered' || self.current_status == 'on hold' || self.current_status.nil?
    end
    
    def on_hold
        return self.current_status == 'on hold' 
    end
    
    def delivery_sent_already
        return (self.current_status == 'sent' && ((DateTime.now - self.last_filled_on.to_datetime)*24).to_i > 5) 
    end
    
    def details_missing
        return self.dob.nil? || self.phone_number.nil? || self.dob.blank? || self.phone_number.nil?
    end
    
    def not_refill?
        return self.refill_requested == false && self.delivery_requested.nil? 
    end
    
    def not_delivery?
        return self.refill_requested.nil? && self.delivery_requested == false
    end
    
    def not_refill_or_delivery?
        return (self.refill_requested.nil? && self.delivery_requested.nil?) || (self.refill_requested == false && self.delivery_requested == false)
    end
    
    def issue_present
        return self.current_status == 'inactive' 
    end
    
    def delivery_requested?
        return self.delivery_requested == true 
    end
    
    def get_delivery_details
        return DeliveryRequest.find_by(rx: self.rx, active: true)
    end
    
    def object?
        return self.is_a?(Rx) 
    end
    
end
