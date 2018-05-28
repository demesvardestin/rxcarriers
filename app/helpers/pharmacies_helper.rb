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
        url.include?("/dashboard")
    end
    
    def request_path
        url.include?('/requests') 
    end
    
    def account_path
        url.include?('/settings') 
    end
    
    def rx_list_path
        url.include?('/rx') 
    end
    
    def patients_path
        url.include?('/patients') 
    end
    
    def payments_path
        url.include?('/transactions') 
    end
    
    def transaction_path
        url.include?('/transactions') 
    end
    
end
