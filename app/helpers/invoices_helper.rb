module InvoicesHelper
    
    def prettify_nil(value)
        if value.nil?
            'n/a'
        elsif value.length > 30
            value[0..27] + '...'
        else
            value
        end
    end
    
    def render_class
        if params[:period] == 'week'
            Invoice.where(pharmacy_id: current_pharmacy.id).group_by_week(:created_at, format: "%a").count
        elsif params[:period] == 'month'
            Invoice.where(pharmacy_id: current_pharmacy.id).group_by_month(:created_at, format: "%b %Y").count
        else
            Invoice.where(pharmacy_id: current_pharmacy.id).group_by_day_of_week(:created_at, format: "%a").count
        end
    end
    
    def next_payment_attempt
        begin
            Invoice.where(pharmacy_id: current_pharmacy.id).last.billing_date
        rescue
         'n/a'
        end
    end
    
    def url
        request.original_url
    end
    
    def invoices_sum
        @invoices = Invoice.where(pharmacy_id: current_pharmacy.id)
        @invoices.reduce(0) {|sum, invoice| sum += invoice.amount}.to_s
    end
    
    def timestamp(object)
        [object.updated_at.strftime("%B %-dth %Y"), "at", object.updated_at.strftime("%I:%M %p")].join(" ")
    end
    
end
