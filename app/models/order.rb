class Order < ActiveRecord::Base
    
    belongs_to :pharmacy
    has_one :cart
    has_one :refund
    
    scope :this_month, -> { where(requested_at: DateTime.now.at_beginning_of_month.utc..Time.now.utc) }
    scope :last_month, -> { where(requested_at: DateTime.now.at_beginning_of_month.last_month.utc..DateTime.now.at_end_of_month.last_month.utc) }
    scope :this_week, -> { where(requested_at: DateTime.now.at_beginning_of_week.utc..Time.now.utc) }
    scope :last_week, -> { where(requested_at: DateTime.now.at_beginning_of_week.last_week.utc..DateTime.now.at_end_of_week.last_week.utc) }
    scope :this_year, -> { where(requested_at: DateTime.now.at_beginning_of_year.utc..Time.now.utc) }
    scope :last_year, -> { where(requested_at: DateTime.now.at_beginning_of_year.last_year.utc..DateTime.now.at_end_of_year.last_year.utc) }
    
    def self.popular_items(period=nil)
        self.this_month.map(&:item_list_array).flatten.sort.uniq[0..14]
    end
    
    def item_list_array
        self.item_list.split(', ') 
    end
    
    def item_list_count_array
        self.item_list_count.split(', ') 
    end
    
    def get_item(id)
        Item.find_by(id: id)
    end
    
    def self.unprocess_all
        self.all.each { |o| o.update(processed: false, requested_at: DateTime.now) } 
    end
    
    def self.process_all
        self.all.each {|o| o.update(processed: true) } 
    end
    
    def self.deliver_all
        self.all.each {|o| o.update(delivered: true) } 
    end
    
    def get_items
        self.item_list_array.map.with_index {|i, idx| "(#{self.item_list_count_array[idx]}) " + Item.find_by(id: i).name } 
    end
    
    def street_address_with_apartment
        if !self.apartment_number.nil?
            self.street_address + ' ' + self.apartment_number
        else
            self.street_address
        end
    end
    
    def self.current_pharmacy
         
    end
    
    def self.totals_to_array(pharma_id, period=nil)
        case period
        when 'this month'
            self.all.where(pharmacy_id: pharma_id, requested_at: DateTime.now.at_beginning_of_month.utc..Time.now.utc).map {|o| o.total.to_f }
        when 'this week'
            self.all.where(pharmacy_id: pharma_id, requested_at: DateTime.now.at_beginning_of_week.utc..Time.now.utc).map {|o| o.total.to_f }
        when 'this year'
            self.all.where(pharmacy_id: pharma_id, requested_at: DateTime.now.at_beginning_of_year.utc..Time.now.utc).map {|o| o.total.to_f }
        else
            self.all.where(pharmacy_id: pharma_id).map {|o| o.total.to_f }
        end
    end
    
    def self.totals_to_array_last_month(pharma_id)
        self.all.where(pharmacy_id: pharma_id, requested_at: DateTime.now.at_beginning_of_month.last_month.utc..DateTime.now.at_end_of_month.last_month.utc).map {|o| o.total.to_f }
    end
    
    def self.totals_to_array_last_week(pharma_id)
        self.all.where(pharmacy_id: pharma_id, requested_at: DateTime.now.at_beginning_of_week.last_week.utc..DateTime.now.at_end_of_week.last_week.utc).map {|o| o.total.to_f }
    end
    def self.totals_to_array_last_year(pharma_id)
        self.all.where(pharmacy_id: pharma_id, requested_at: DateTime.now.at_beginning_of_year.last_year.utc..DateTime.now.at_end_of_year.last_year.utc).map {|o| o.total.to_f }
    end
    
    def self.total_items(pharma_id=nil)
        if !pharma_id.nil?
            self.all.where(pharmacy_id: pharma_id).map {|o| o.item_list_array.length }
        else
            self.all.map {|o| o.item_list_array.length }
        end
    end
    
end
