class Batch < ActiveRecord::Base
    
    # associations
    belongs_to :pharmacy
    has_many :rxes
    
    # scopes
    scope :asc, -> {order("ID ASC")}
    scope :desc, -> {order("ID DESC")}
    scope :asc_date, -> {order("updated_at ASC")}
    scope :desc_date, -> {order("updated_at DESC")}
    scope :requested, -> {where(request_status: 'completed')}
    scope :today, -> {where("created_at >= ?", Time.zone.now.beginning_of_day)}
    scope :last_week, -> {where("created_at >= ?", 1.week.ago)}
    scope :last_month, -> {where("created_at >= ?", 1.month.ago)}
    
    # validations
    # validates_presence_of :notes
    
    # methods
    def self.today
        where("created_at >= ?", Time.zone.now.beginning_of_day)
    end
    
    def self.last_week
        where("created_at >= ?", 1.week.ago)
    end
    
    def self.last_month
        where("created_at >= ?", 1.month.ago)
    end
    
    def self.search(param)
        where('name LIKE ?', "%#{param}%")
    end
    
    def self.timestamp(object)
        [object.updated_at.strftime("%B %-dth %Y"), "at", object.updated_at.strftime("%I:%M %p")].join(" ")
    end
    
    def self.search(param)
        param.strip!
        param.downcase!
        (id_matches(param) + pharmacist_matches(param)).uniq
    end
    
    def self.id_matches(param)
        matches('id', param)
    end
    
    def self.pharmacist_matches(param)
        matches('pharmacist', param)
    end
    
    def self.matches(field_name, param)
        where("lower(#{field_name}) like ?", "%#{param}%")
    end
    
    def self.generate_id
        rand(1000000..9999999)
    end
    
    def self.second_to_last
        self.last(2).first 
    end
    
    # POSTMATES DELIVERY SECTION
    
    def self.quote(batch)
        from = batch.pharmacy.full_address
        to   = batch.address
        client = self.configure_postmates
        client.quote(pickup_address: from, dropoff_address: to)
    end
    
    def self.request_courier(batch)
        from = batch.pharmacy.full_address
        to   = batch.address
        package = { 
                    manifest: "food",
                    pickup_name: "Restaurant",
                    pickup_address: from,
                    pickup_phone_number: "3473362973",
                    dropoff_name: "Apartment",
                    dropoff_address: to,
                    dropoff_phone_number: "7185940158",
                    quote_id: batch.quote_id
        }
        client = self.configure_postmates
        client.create(package)
    end
    
    def self.configure_postmates
        @client = Postmates.new
        @client.configure do |config|
          config.api_key = 'cdfeb8ac-f481-4a40-bdc9-c1b2631d8692'
          config.customer_id = 'cus_LnOv64fBP0ORt-'
        end
        @client
    end
    
end