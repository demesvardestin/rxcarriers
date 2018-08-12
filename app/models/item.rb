class Item < ActiveRecord::Base
    belongs_to :pharmacy
    belongs_to :inventory
    belongs_to :item_category
    belongs_to :cart
    
    scope :popular, -> { where(requested_at: DateTime.now.at_beginning_of_month.utc..Time.now.utc) }
    
    def get_price
        self.price.to_f 
    end
    
    def item_size
       [size, size_type].join(' ')
    end
    
    def item_price_for(item)
        Item.find_by(id: item).price
    end
    
    def units_sold_for(pharmacy, item, period=nil)
        pharmacy.orders_for(period).map(&:item_list_array).flatten.select {|i| i.to_i == item }.count
    end
    
    def revenue_per_unit_for(pharmacy_id, item, period=nil)
        pharmacy = Pharmacy.find_by(id: pharmacy_id)
        units_sold_for(pharmacy, item, period) * item_price_for(item).to_f.round(2)/100
    end
    
    def in_cart(cart)
        cart.item_list.split(', ').include?("#{self.id}") ? true : false 
    end
    
    def shorten_name
        self.name.length > 25 ? "#{self.name[0..25]}..." : self.name
    end
    
    def minify_name(length)
        self.name.length > length ? "#{self.name[0..length]}..." : self.name
    end
    
    def is_taxable?
        self.taxable == true 
    end
    
    def self.expire_soon(pharmacy_id)
        self.all.where(pharmacy_id: pharmacy_id).select do |i|
            (((i.expiration.to_time - DateTime.now)/86400).round / 30) < 6
        end
    end
    
    def self.available
        where('quantity > ', 0) 
    end
    
    def self.low_available_count(pharmacy_id)
        self.all.where(pharmacy_id: pharmacy_id).select do |i|
            i.quantity.to_i < 10
        end
    end
    
    def self.search(param)
        param.strip!
        param.downcase!
        param = param.split('-').join('')
        (name_matches(param) + ndc_matches(param)).uniq
    end
    
    def self.name_matches(param)
        matches('name', param)
    end
    
    def self.ndc_matches(param)
        matches('ndc', param)
    end
    
    def self.matches(field_name, param)
        where("lower(#{field_name}) like ?", "%#{param}%")
    end
    
    def self.match_ndc(param, pharmacy_id)
        self.all.where(pharmacy_id: pharmacy_id).select do |i|
            i.ndc.split('-').join('').include?(param) if !i.ndc.nil?
        end
    end
    
    def self.find_by_ndc(ndc, pharmacy_id)
        self.all.where(pharmacy_id: pharmacy_id).select do |i|
            i.ndc.split('-').join('') == ndc if !i.ndc.nil?
        end
    end
    
end
