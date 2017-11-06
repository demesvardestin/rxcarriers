class Request < ActiveRecord::Base
    
    belongs_to :pharmacy
    
    def pharmacy_distance(pharmacy)
        # distance = Geocoder::Calculations.distance_between() 
    end
  
    def self.send_request(original_request)
        # template message for each request
        @pharmacy = Pharmacy.find(original_request.pharmacy_id)
        message = "[Type: new request - ID: #{original_request.batch_id}]\n\nNew delivery request from #{@pharmacy.name} at #{@pharmacy.full_address}. Reply 'yes' to accept this request."
        # look for the driver's response
        Driver.fetch_driver_response(original_request, @pharmacy, message, initial_driver=nil, req_type=true)
        # add this message to the request
        Request.find_by(id: original_request.id).update!(body: 'Sent from your Twilio trial account - ' + message)
    end
    
    def self.resend_request(batch_id, pharmacy, req, driver)
        # text cancelling driver with udpate
        Driver.request_cancelled(driver, pharmacy)
        # template message for resending request to drivers
        text_message = "[Type: request resend - ID: #{batch_id}]\n\nUpdated delivery request from #{pharmacy.name} at #{pharmacy.street}, #{pharmacy.town} #{pharmacy.zipcode}. Reply 'yes' to accepted this request."
        # look for the driver's response
        Driver.fetch_driver_response(req, pharmacy, text_message, driver, false)
        # add this message to the request
        Request.find_by(id: req.id).update!(body:'Sent from your Twilio trial account - ' + text_message)
    end
    
end
