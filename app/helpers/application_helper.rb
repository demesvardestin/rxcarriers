module ApplicationHelper
    
    def driver_status
        if (current_driver.onboarding_complete == true) || (current_driver.onfido_created == true && current_driver.registration_completed.nil?)
            'drivers/driver_home'
        elsif current_driver.onfido_created == nil
            'drivers/acct_under_review'
        end
    end
    
    def footer
        if current_driver
            if current_driver.onboarding_complete
                'layouts/empty'
            else
                'layouts/footer'
            end
        elsif current_pharmacy
            'layouts/empty'
        else
            'layouts/footer'
        end
    end
    
end
