class Request < ActiveRecord::Base
    
    belongs_to :pharmacy
  
    def self.initiate_request(batch, patients, pharmacy)
        req = {
          "id" => pharmacy.id,
          "location" => pharmacy.full_address
        }
        return req
    end
    
    def pharmacy_distance(pharmacy)
        # distance = Geocoder::Calculations.distance_between() 
    end
  
    def self.send_request(batch, pharmacy, request_location, original_request)
        # template message for each request
        message = "[Message Type: new request]\n\nNew delivery request from #{pharmacy.name} at #{pharmacy.street}, #{pharmacy.town} #{pharmacy.zipcode}. Est total delivery route mileage: 5mi. Reply 'yes' to accept this request."
        # look for the driver's response
        Driver.fetch_driver_response(request_location, batch.id, pharmacy, message, initial_driver=nil, req_type=true)
        # add this message to the request
        Request.find_by(id: original_request.id).update!(body: 'Sent from your Twilio trial account - ' + message)
    end
    
    def self.resend_request(batch, pharmacy, req, driver)
        # text cancelling driver with udpate
        Driver.request_cancelled(driver, pharmacy)
        # template message for resending request to drivers
        text_message = "[Message Type: request resend]\n\nUpdated delivery request from #{pharmacy.name} at #{pharmacy.street}, #{pharmacy.town} #{pharmacy.zipcode}. Est total delivery route mileage: #{total_delivery_route_mileage}. Reply 'yes' to accepted this request."
        # look for the driver's response
        Driver.fetch_driver_response(req, batch.id, pharmacy, text_message, initial_driver=driver, new_req=false)
        # add this message to the request
        Request.find_by(id: req.id).update!(body:'Sent from your Twilio trial account - ' + message)
    end
    
end
