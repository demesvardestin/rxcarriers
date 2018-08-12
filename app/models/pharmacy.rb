class Pharmacy < ActiveRecord::Base
  
    # Include default devise modules. Others available are:
    # :confirmable, :lockable, :timeoutable and :omniauthable
    devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
    
    # associations
    geocoded_by :full_address
    after_validation :geocode
    has_many :patients, :as => :patable
    has_many :invoices
    has_many :deliveries
    has_many :reviews
    has_many :items
    has_many :item_categories
    has_one :inventory
    has_many :orders
    has_many :refunds
    has_many :help_tickets
    has_many :notifications
    
    # validations
    has_attached_file :avatar, styles: { medium: "300x300>", thumb: "100x100>", placeholder: '/images/user_full.png' }
    validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\z/
    
    # methods
    
    def self.search(param)
        param.strip!
        param.downcase!
        (name_matches(param) + address_matches(param) + phone_matches(param)).uniq
    end
    
    def self.sort_search(param)
      if Pharmacy.search(param).empty?
        return Pharmacy.search_nearby(param)
      end
      return Pharmacy.search(param)
    end
    
    def self.search_nearby(location)
        if location.nil?
          return 'Invalid location'
        end
        return Pharmacy.near(location, 5).all
    end
    
    def self.name_matches(param)
        matches('name', param)
    end
    
    def self.address_matches(param)
        matches('town', param)
    end
    
    def self.phone_matches(param)
        matches('state', param)
    end
    
    def self.matches(field_name, param)
        where("lower(#{field_name}) like ?", "%#{param}%")
    end
    
    def full_address
        [street, town, state, zipcode].join(', ')
    end
    
    def slug
        unslug = self.name + ' ' + self.town + ' ' + self.state
        return unslug.downcase.split(' ').join('-')
    end
    
    def to_slug(string)
        string.downcase.split(' ').join('-')
    end
    
    def unslug(string)
        string.downcase.split('-').join(', ')
    end
    
    def url
        "/pharmacies/#{self.slug}/#{self.id}"
    end
    
    def full_address_without_zip
        [street, town, state].join(', ')
    end
    
    def not_subscribed
        return self.on_trial.nil? || self.on_trial == false || self.delinquent == true || self.is_subscribed == false || self.is_subscribed.nil?
    end
    
    def last_four
      last_four = Stripe::Customer.retrieve(self.stripe_cus).sources.first['last4']
      return last_four
    end
    
    def card_brand
      brand = Stripe::Customer.retrieve(self.stripe_cus).sources.first['brand'].downcase
      return brand
    end
    
    def batches
      @batches = Batch.where(pharmacy_id: self.id).all
      return @batches
    end
    
    def has_batches?
      batches.count > 0 ? 'true' : 'false'
    end
    
    def name_shortened
      if self.name.length > 18
        self.name[0..17] + '...'
      else
        name
      end
    end
    
    def delivery
      case self.delivers.downcase
      when 'yes'
        'Free delivery'
      when 'no'
        'Does not deliver'
      else
        'Does not always deliver'
      end
    end
    
    def delivery_color
      case self.delivers.downcase
      when 'yes'
        'theme-green'
      when 'no'
        'theme-red'
      else
        'theme-yellow'
      end
    end
    
    def billing_attributes
      self.card_number.present? && self.exp_year.present? && self.exp_month.present? && self.bill_street.present? && self.bill_city.present? && self.bill_state.present? && self.bill_zip.present?
    end
    
    def is_not_related_to(cart)
      @pharmacy = cart.get_pharmacy
      return if @pharmacy.nil?
      cart.get_pharmacy.id != self.id
    end
    
    def orders_for(period)
      case period
      when 'this month'
          Order.this_month.where(pharmacy_id: self.id).all
      else
          Order.where(pharmacy_id: self.id).all
      end
    end
    
end
