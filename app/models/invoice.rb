class Invoice < ActiveRecord::Base
    belongs_to :pharmacy
    belongs_to :order
    
    # scopes
    scope :today, -> { where("date_trunc('day',created_at) = date_trunc('day',now())") }
    scope :asc_amount, -> {order("CAST(final AS INT) ASC")}
    scope :desc_amount, -> {order("CAST(final AS INT) DESC")}
    scope :asc_date, -> {order("updated_at ASC")}
    scope :desc_date, -> {order("updated_at DESC")}
    scope :refunded, -> { where("stripe_status = ? AND paid = ?", 'refunded', true) }
    scope :paid, -> { where("stripe_status = ? AND paid = ?", 'paid', true) }
    scope :pending, -> { where("stripe_status = ? AND paid = ?", 'pending', false) }
    
    # methods
    
    def self.set_invoice(fee, net, order, cart)
        Invoice.create(
            pharmacy_id: order.pharmacy_id,
            description: "Order from cart ##{cart.id}",
            stripe_invoice_id: order.stripe_charge_id,
            currency: 'usd',
            paid: true,
            stripe_status: 'paid',
            billing_date: Time.zone.now,
            order_id: order.id,
            transaction_id: self.generate_confirmation,
            subtotal: cart.total_cost,
            tax: cart.calculate_tax,
            tip: cart.tip_amount,
            platform_fee: fee.to_s,
            final: net.to_s
        )
    end
    
    def self.generate_confirmation
        rand(100000..999999) 
    end
    
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
