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
            self.twilio_client.api.account.messages.create(
              from: '+13474640621',
              to: driver.number,
              body: text_message
            )
            # upon sending message, retrieve message details
            to_driver = self.twilio_client.api.account.messages.list(
              to: driver.number,
              from: '+13474640621'
            #   body: text_message
            )
            to_driver.each do |message|
                if message == to_driver.last
                    # store message in database
                    RequestMessage.create!(driver_number: driver.number, from_number: '+13474640621', 
                                    message_sid: message.sid, date_created: message.date_created, message_body: message.body, date_sent: message.date_sent,
                                    pharmacy_id: pharmacy.id, batch_id: package_id, request_type: req_type[new_req])
                    # delete message to avoid overload
                    message.delete
                end
            end
        end
    end
    
    def self.omit_driver(driver)
        @drivers = Driver.all
        @new_list = []
        @new_list.concat @drivers
        unless driver == nil
            @new_list.delete_at(@drivers.index(driver))
        end
        return @new_list
    end
    
    def self.request_cancelled(driver)
        request_cancellation = "[Message Type: request cancellation]\n\nPickup cancelled."
        Driver.twilio_client.api.account.messages.create(
                from: '+13474640621',
                to: driver.number,
                body: request_cancellation
            )
        self.twilio_client.api.messages.list(
                to: driver.number,
                from: '+13474640621',
                body: request_cancellation
            ).last do |message|
                # store message in database
                CancellationMessage.create!(driver_number: driver.number, from_number: '+13474640621', 
                                message_sid: message.sid, date_created: message.datecreated, message_body: message.body,
                                pharmacy_id: pharmacy.id, type: 'cancellation')
                # delete message to avoid overload
                message.delete
            end
    end
    
    def self.twilio_client
        account_sid = 'AC7b0eae323dc72522bb616648567a7de6'
        auth_token = '2a27c125b10a4429e8a24ccd08584670'
        client = Twilio::REST::Client.new(account_sid, auth_token)
        # service = client.notify.v1.services('ISefbdcf15a7dce91b9e64dee9e0d485bf') we will use this later
        return client
    end
    
    def self.filter_by_location(request_location, drivers)
        drivers = drivers.select do |driver|
            # calculate distance between request location and driver to determine if we should message them
           Geocoder::Calculations.distance_between(request_location, driver.full_address) < 10.5
        end
        return drivers
    end
    
    # notify other drivers that someone has already accepted the request
    def self.notify_drivers_request_invalidated(driver, pharmacy, _batch_id)
        request_update = "Update: This request has been accepted by another courier."
        # find the initial request
        initial_request = Request.find_by(batch_id: _batch_id)
        @drivers = Driver.all
        @drivers.each do |recipient|
            # message each driver except the one who accepted the request
            unless recipient == driver
                Driver.twilio_client.api.account.messages.create(
                    from: '+13474640621',
                    to: driver.number,
                    body: request_update
                )
                # retrieve message immediately after
                self.twilio_client.api.messages.list(
                    to: driver.number,
                    from: '+13474640621',
                    body: request_update
                ).last do |message|
                    # delete message to avoid overload
                    message.delete
                end
            end
        end
    end
    
end
