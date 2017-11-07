class Request < ActiveRecord::Base
    
    belongs_to :pharmacy
    
    def pharmacy_distance(pharmacy)
        # distance = Geocoder::Calculations.distance_between() 
    end
  
    def self.send_request(original_request)
        @pharmacy = Pharmacy.find(original_request.pharmacy_id)
        message = "[Type: new request - ID: #{original_request.batch_id}]\n\nNew delivery request from #{@pharmacy.name} at #{@pharmacy.full_address}. Reply 'yes' to accept this request."
        @request = original_request
        @request.update!(body: 'Sent from your Twilio trial account - ' + message)
        Driver.fetch_driver_response(original_request, @pharmacy, message)
    end
    
    def self.resend_request(batch_id, pharmacy, req, driver, request_message)
        Driver.request_cancelled(driver, pharmacy, batch_id)
        text_message = "[Type: request resend - ID: #{batch_id}]\n\nUpdated delivery request from #{pharmacy.name} at #{pharmacy.full_address}. Reply 'yes' to accepted this request."
        Driver.fetch_driver_response(req, pharmacy, text_message, request_message, driver, false)
        Request.find_by(id: req.id).update!(body:'Sent from your Twilio trial account - ' + text_message)
    end
    
    def self.check_delivery_status
        Request.initialize_twilio
        loop do
            sleep(3600)
            Request.where(status: 'accepted').each do |req|
                @driver = Driver.find_by(number: req.driver)
                warning = "[Type: delivery status - ID: #{req.batch_id}]\n\nHey #{@driver.first_name}, we have not yet received the status of your delivery. Please reply 'completed' if you have completed your delivery."
                if req.updated_at > 120.minutes.ago
                    @client.api.account.messages.create(
                        from: '+13474640621',
                        to: req.driver,
                        body: warning
                    )
                end
            end
        end
    end
    
    def self.initialize_twilio
        account_sid = 'AC7b0eae323dc72522bb616648567a7de6'
        auth_token = '2a27c125b10a4429e8a24ccd08584670'
        @client = Twilio::REST::Client.new account_sid, auth_token
    end
    
end
