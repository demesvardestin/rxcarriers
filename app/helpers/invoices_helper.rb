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
        @all_invoices = Invoice.where(pharmacy_id: current_pharmacy.id).today
        @all_invoices.reduce(0) {|sum, invoice| sum += invoice.amount}.to_s
    end
    
    def timestamp(object)
        [object.updated_at.strftime("%B %-dth %Y"), "at", object.updated_at.strftime("%I:%M %p")].join(" ")
    end
    
    def to_dollar(item)
        item.to_s.prepend("$") 
    end
    
    def status(invoice)
        if invoice.status.nil?
            return 'failed'
        end
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
    
    def failed(array)
        inv = array.select{|a| a.stripe_status == 'failed'}
        return inv
    end
    def succeeded(array)
        inv = array.select{|a| a.stripe_status == 'succeeded'}
        return inv
    end
    def pending(array)
        inv = array.select{|a| a.stripe_status == 'pending'}
        return inv
    end
    
    def recent_invoices
        @pharmacy = current_pharmacy
        @invoices = Invoice.where(id: @pharmacy.id).order('updated_at DESC')
        return @invoices
    end
    
    def old_invoices
        @pharmacy = current_pharmacy
        @invoices = Invoice.where(id: @pharmacy.id).order('updated_at ASC')
        return @invoices
    end
    
    def invoice_sort
        url = request.original_url
        url_end = url[url.index("/payment-settings")..-1]
        case url_end
            when "/payment-settings?status=pending"
                "pending_payments"
            when "/payment-settings?status=succeeded"
                "succeeded_payments"
            when "/payment-settings?status=failed"
                "refunded_payments"
            when "/payment-settings?amount=asc"
                "low_high"
            when "/payment-settings?amount=desc"
                "high_low"
            when "/payment-settings?date=asc"
                "old_new"
            when "/payment-settings?date=desc"
                "new_old"
            else
                "all"
        end
    end
    
    def current_pharmacy_available_balance
        Stripe::Balance.retrieve({:stripe_account => current_pharmacy.stripe_cus}).available[0].amount/100.round(2)
    end
    
    def current_pharmacy_pending_balance
        Stripe::Balance.retrieve({:stripe_account => current_pharmacy.stripe_cus}).pending[0].amount/100.round(2)
    end
    
end
