module DriversHelper
    
    def find_pharmacy(id)
        @pharmacy = Pharmacy.find(id)
    end
    
    def find_batch(id)
        @batch = Batch.find(id) 
    end
    
    def card_content
        url = request.original_url
        if url.include?("/driver/#{current_driver.id}/settings/account-info")
            'form'
        elsif url.include?("/driver/#{current_driver.id}/settings/car-info")
            'car_info'
        elsif url.include?('settings/password')
            'devise/registrations/edit'
        elsif url.include?("/driver/#{current_driver.id}/settings/advanced")
            'advanced'
        else
            'form'
        end
    end
end
