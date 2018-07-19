class Invoice < ActiveRecord::Base
    belongs_to :pharmacy
    
    # scopes
    scope :today, -> { where("date_trunc('day',created_at) = date_trunc('day',now())") }
    scope :asc_amount, -> {order("amount ASC")}
    scope :desc_amount, -> {order("amount DESC")}
    scope :asc_date, -> {order("updated_at ASC")}
    scope :desc_date, -> {order("updated_at DESC")}
    
    # methods
    def self.today
        where("created_at >= ?", Time.zone.now.beginning_of_day)
    end
    
    def status
        
        # check for nil value
        if self.status.nil?
            return 'failed'
        end
        
        # parse value, return appropriate partial
        begin
            case invoice.status
                when 'succeeded'
                    'succeeded'
                else
                    'failed'
            end
        rescue
            'failed'
        end 
    end
    
    def total
        (self.value.to_i/100).to_f 
    end
    
    def shorten(obj)
        return obj[0..45] + '...' 
    end
    
end
