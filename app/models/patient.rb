class Patient < ActiveRecord::Base
    
    # associations
    belongs_to :pharmacy
    
    # geocoding
    geocoded_by :address
    after_validation :geocode
    
    # scopes
    scope :insured, -> {where(insured: 'yes')}
    scope :uninsured, -> {where(insured: 'no')}
    scope :asc_name, -> {order("name ASC")}
    scope :desc_name, -> {order("name DESC")}
    
    # validations
    validates_presence_of :name
    validates_presence_of :address
    validates_presence_of :phone, uniqueness: true
    validates_presence_of :delivery_instructions
    
    # methods
    def self.search(param)
        param.strip!
        param.downcase!
        (name_matches(param) + address_matches(param) + phone_matches(param) + dob_matches(param)).uniq
    end
    
    def self.name_matches(param)
        matches('name', param)
    end
    
    def self.address_matches(param)
        matches('address', param)
    end
    
    def self.phone_matches(param)
        matches('phone', param)
    end
    
    def self.dob_matches(param)
        matches('dob', param)
    end
    
    def self.matches(field_name, param)
        where("lower(#{field_name}) like ?", "%#{param}%")
    end
end
