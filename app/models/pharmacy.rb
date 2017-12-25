class Pharmacy < ActiveRecord::Base
  
    # Include default devise modules. Others available are:
    # :confirmable, :lockable, :timeoutable and :omniauthable
    devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
    
    # associations
    geocoded_by :full_address
    after_validation :geocode
    has_many :requests
    has_many :patients, :as => :patable
    has_one :charge
    has_many :deliveries
    has_many :supports
    
    # validations
    has_attached_file :avatar, styles: { medium: "300x300>", thumb: "100x100>" }
    validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\z/
    validates :name, presence: true
    validates :street, presence: true
    validates :number, uniqueness: true, presence: true
    validates :website, presence: true
    validates :email, {uniqueness: true, presence: true}
    
    # methods
    def full_address
        [street]
    end
    
    def name_shortened
      if self.name.length > 18
        self.name[0..17] + '...'
      else
        name
      end
    end
    
    def billing_attributes
      self.card_number.present? && self.exp_year.present? && self.exp_month.present? && self.bill_street.present? && self.bill_city.present? && self.bill_state.present? && self.bill_zip.present?
    end
    
    def self.search(string)
      split_string = string.scan(/\w+/)
      first_start = split_string[0][0..3]
      first_end = split_string[0][-1,3]
      last_start = split_string[1][0..3] if split_string.length > 1
      last_end = split_string[1][-1,3] if split_string.length > 1
      results = Pharmacy.select do |ph|
        total = self.check_start(ph.name.downcase.scan(/\w+/)[0], first_start, last_start) + 
              self.check_end(ph.name.downcase.scan(/\w+/)[1], first_end, last_end) + 
              self.check_word(ph.name, string)
        total >= 1
      end
      return results
    end
    
    def self.check_start(x, y, z=nil)
      counter = 0
      counter += 1 if x.start_with?(y)
      counter += 1 if z != nil && x.start_with?(z)
      return counter
    end
    
    def self.check_end(x, y, z=nil)
      counter = 0
      counter += 1 if x.end_with?(y)
      counter += 1 if z != nil && x.end_with?(z)
      return counter
    end
    
    def self.check_word(x, y)
      counter = 0
      x == y ? counter += 1 : counter = 0
      return counter
    end
    
end
