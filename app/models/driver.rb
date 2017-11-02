class Driver < ActiveRecord::Base
    
    geocoded_by :full_address
    after_validation :geocode
    
    def full_address
        [street, town].join(", ")
    end
    
    def self.fetch_driver_response(req, package_id, pharmacy, text_message, initial_driver=nil, new_req=true)
        # store request types for further use
        req_type = {true => 'new request', false => 'request resend'}
        # filter all drivers by location before going through selection process
        drivers = Driver.omit_driver(initial_driver)
        @drivers = Driver.filter_by_location(req['location'], drivers)
        @drivers.each do |driver|
            # send a message request to drivers
            self.initialize_twilio.api.account.messages.create(
              from: '+13474640621',
              to: driver.number,
              body: text_message
            )
            # upon sending message, retrieve message details
            to_driver = self.initialize_twilio.api.account.messages.list(
              to: driver.number,
              from: '+13474640621'
            #   body: text_message
            )
            i = 1
            while i >= 1
                break if to_driver.count == 0
                to_driver.each do |message|
                    # store message in database
                    RequestMessage.create!(driver_number: driver.number, from_number: '+13474640621', 
                                    message_sid: message.sid, date_created: message.date_created, message_body: message.body, date_sent: message.date_sent,
                                    pharmacy_id: pharmacy.id, batch_id: package_id, request_type: req_type[new_req])
                    # delete message to avoid overload
                    message.delete
                end
                i += 1
            end
        end
    end
    
    def self.omit_driver(driver)
        @drivers = Driver.all
        unless driver == nil
            @drivers.delete_at(@drivers.index(driver))
        end
        return @drivers
    end
    
    def self.request_cancelled(driver, pharmacy)
        request_cancellation = "[Message Type: request cancellation]\n\n#{driver.first_name}, your pickup at #{pharmacy.name} has been cancelled."
        Driver.initialize_twilio.api.account.messages.create(
                from: '+13474640621',
                to: driver.number,
                body: request_cancellation
            )
        self.initialize_twilio.api.account.messages.list(
                to: driver.number,
                from: '+13474640621'
                # body: 'Sent from your Twilio trial account - ' + request_cancellation
            ).last do |message|
                # store message in database
                CancellationMessage.create!(driver_number: driver.number, from_number: '+13474640621', 
                                message_sid: message.sid, date_created: message.date_created, message_body: message.body,
                                pharmacy_id: pharmacy.id, request_type: 'cancellation')
                # delete message to avoid overload
                message.delete
            end
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
        request_update = "Message Type: request update: This request has been accepted by another courier."
        @drivers = Driver.all
        @drivers.each do |recipient|
            # message each driver except the one who accepted the request
            unless recipient == driver
                Driver.initialize_twilio.api.account.messages.create(
                    from: '+13474640621',
                    to: recipient.number,
                    body: request_update
                )
                # retrieve message immediately after
                self.initialize_twilio.api.acount.messages.list(
                    to: recipient.number,
                    from: '+13474640621'
                    # body: 'Sent from your Twilio trial account - ' + request_update
                ).last do |message|
                    # delete message to avoid overload
                    message.delete
                end
            end
        end
    end
    
end
