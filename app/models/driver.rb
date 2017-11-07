class Driver < ActiveRecord::Base
    
    geocoded_by :full_address
    after_validation :geocode
    scope :available, -> {where(requested: false)}
    
    def full_address
        [street, town].join(", ")
    end
    
    def self.fetch_driver_response(req, pharmacy, text_message, request_message=nil, initial_driver=nil, new_req=true)
        req_type = {true => 'new request', false => 'request resend'}
        @drivers = Driver.omit_driver(initial_driver)
        if @drivers != nil
            Driver.available.filter_by_location(pharmacy.full_address, @drivers).each do |driver|
                self.initialize_twilio.api.account.messages.create(
                  from: '+13474640621',
                  to: driver.number,
                  body: text_message
                )
                driver.update!(requested: true)
                if request_message
                    RequestMessage.where(driver_number: driver.number, message_body: 'Sent from your Twilio trial account - ' + text_message, driver: initial_driver.number).update!(
                        request_type: req_type[new_req],
                        driver: nil
                    )
                else
                    RequestMessage.create!(
                        driver_number: driver.number, 
                        from_number: '+13474640621',
                        message_body: 'Sent from your Twilio trial account - ' + text_message,
                        batch_id: req.batch_id,
                        pharmacy_id: pharmacy.id,
                        request_type: req_type[new_req],
                        driver: nil,
                        status: 'in progress'
                    )
                end
            end
        end
    end
    
    def self.omit_driver(driver)
        @drivers = Driver.select do |d|
           d != driver 
        end
        return @drivers
    end
    
    def self.request_cancelled(driver, pharmacy, batch)
        request_cancellation = "[Message Type: request cancellation]\n\n#{driver.first_name}, your pickup at #{pharmacy.name} has been cancelled."
        Driver.initialize_twilio.api.account.messages.create(
            from: '+13474640621',
            to: driver.number,
            body: request_cancellation
        )
        CancellationMessage.create!(
            driver_number: driver.number, 
            from_number: '+13474640621', 
            message_body: request_cancellation,
            pharmacy_id: pharmacy.id,
            batch_id: batch,
            request_type: 'cancellation'
        )
    end
    
    def self.initialize_twilio
        account_sid = 'AC7b0eae323dc72522bb616648567a7de6'
        auth_token = '2a27c125b10a4429e8a24ccd08584670'
        @client = Twilio::REST::Client.new(account_sid, auth_token)
        return @client
    end
    
    def self.filter_by_location(request_location, drivers)
        drivers = drivers.select do |driver|
           Geocoder::Calculations.distance_between(request_location, driver.full_address) < 5.5
        end
        return drivers
    end
    
    # notify other drivers that someone has already accepted the request
    def self.notify_drivers_request_invalidated(driver)
        request_update = "[Message Type: request update]\n\nThis request has been accepted by another courier."
        @drivers = Driver.all
        @drivers.each do |recipient|
            unless recipient == driver
                Driver.initialize_twilio.api.account.messages.create(
                    from: '+13474640621',
                    to: recipient.number,
                    body: request_update
                )
                recipient.update!(requested: false)
            end
            RequestMessage.find_by(driver_number: recipient.number, driver: nil).update!(driver: driver.number)
        end
    end
    
end
