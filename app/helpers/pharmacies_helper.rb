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
        url = request.original_url
        if url.include?('settings/account-info')
            'form'
        elsif url.include?('settings/billing-info')
            'bank_account_form'
        elsif url.include?('settings/password')
            'devise/registrations/edit'
        elsif url.include?('settings/advanced')
            'advanced'
        else
            'form'
        end
    end
    
end
