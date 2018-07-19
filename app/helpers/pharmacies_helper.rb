module PharmaciesHelper
    
    def url
        request.original_url
    end
    
    def check_website(website)
        begin
            website.start_with?('www') ? website : website.prepend('www.')
        rescue
            'no website listed'
        end
    end
    
    def card_content
        if url.include?('settings/account-info')
            'form'
        elsif url.include?('settings/billing-info')
            if current_pharmacy.card_token
                'pharmacies/card_data'
            else
                'pharmacies/card_form'
            end
        elsif url.include?('settings/password')
            'devise/registrations/edit'
        elsif url.include?('settings/advanced')
            'advanced'
        else
            'form'
        end
    end
    
    # def home
    #     url.include?("/batches")
    # end
    
    def home
        url.include?("/dashboard") || url.ends_with?('https://udemy-class-demo07.c9users.io/') || url == 'https://www.rxcarriers.com'
    end
    
    def request_path
        url.include?('/requests') 
    end
    
    def account_path
        url.include?('/settings') || url.include?('/choose_subscription') 
    end
    
    def history_path
        url.include?('/payment-history') || url.include?('/transaction') 
    end
    
    def bag_history_path
        url.include?('/bag-history')
    end
    
    def bags_path
        url.include?('/bags') 
    end
    
    def payments_path
        url.include?('/transactions') 
    end
    
    def transaction_path
        url.include?('/transactions') 
    end
    
    def check_current_plan(plan)
        @plan = StripePlan.find_by(pharmacy_id: current_pharmacy.id)
        if !@plan.nil?
            name = @plan.name
        end
        if name == plan
            'Cancel subscription'
        else
            'Change subscription'
        end
    end
    
end
