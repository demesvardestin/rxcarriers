class Batch < ActiveRecord::Base
    
    belongs_to :pharmacy
    has_many :patients, :as => :patable
    
    def self.respond_to_drivers(number, pharmacy, initial_request, batch_id)
        directions = "Thank you for accepting this request. Your pickup is now ready at #{pharmacy.name}.\n
                        For verification purposes, present your ID once you arrive.\nTo cancel this pickup, reply 'cancel'."
        # ensuring that we select the first one to respond to
        while initial_request.count == 1
            # figure out if this particular request has already been picked up
            driver = Driver.find_by(phone_number: number)
            # if the driver accepted the request, we notify the pharmacy
            # Pharmacy.notify_pharmacy(pharmacy, driver) --> may use this later on
            # we then charge the pharmacy. timing of this may vary
            # Charge.create!(pharmacy_id: pharmacy.id, batch_id: _batch_id)
            # find a way to notify all drivers besides this one, that the request is no longer valid
            Driver.notify_drivers_request_invalidated(driver, pharmacy, batch_id)
            # initiate a final update on the initial request to record the driver's info
            initial_request.update!(delivery_driver: driver)
            # message the driver with directions
            Driver.twilio_client.api.account.messages.create(
                    from: '+13474640621',
                    to: number,
                    body: directions
                )
        end
    end
    
end
def driver_response
    # retrieve message details
    url = request.original_url
    if url.include?('From') && url.include?('Body')
      num_start = url.index('From') + 5
      body_start = url.index('Body') + 5
      number = url[num_start..num_start + 11]
      request_response = url[body_start..body_start + 4].downcase
    end
    # unless number.nil? || request_response.nil?
      # initial_request_message = RequestMessage.find_by(driver_number: number)
      # pharmacy = Pharmacy.find_by(id: initial_request_message.pharmacy_id)
      # initial_request = Request.find_by(body: initial_request_message.message_body)
      # if request_response == 'yes'
      #   initial_request.update!(status: 'accepted', count: count + 1)
      twilio_client
        directions = "Thank you for accepting this request. Your pickup is now ready at MedCab.\n
                        For verification purposes, present your ID once you arrive.\nTo cancel this pickup, reply 'cancel'."
      #   if initial_request.count == 1
      #       Driver.notify_drivers_request_invalidated(driver, pharmacy, batch_id)
      #       initial_request.update!(delivery_driver: driver)
            @client.api.account.messages.create(
                    from: '+13474640621',
                    to: number,
                    body: "Hey!"
                )
      #   end
      # elsif request_response == 'can'
      #   driver = Driver.find_by(number: number)
      #   initial_request = Request.find_by(driver: driver, status: 'accepted', body: initial_request_message)
      #   initial_request.update!(status: 'pending', count: 0)
      #   Request.resend_request(initial_request.batch_id, initial_request.pharmacy, initial_request, driver)
      # end
    # end
end
