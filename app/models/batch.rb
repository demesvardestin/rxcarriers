class Batch < ActiveRecord::Base
    
    belongs_to :pharmacy
    has_many :patients, :as => :patable
    
    def respond_to_drivers(number, pharmacy, request_response, initial_request_message, initial_request, _batch_id)
        directions = "Thank you for accepting this request. Your pickup is now ready at #{pharmacy.name}.\n
                        For verification purposes, present your ID once you arrive.\nTo cancel this pickup, reply 'cancel'."
        # ensuring that we select the first one to respond to
        while initial_request.count == 1
            # figure out if this particular request has already been picked up
            driver = Driver.find_by(phone_number: number)
            # if the driver accepted the request, we notify the pharmacy
            # Pharmacy.notify_pharmacy(pharmacy, driver) --> may use this later on
            # we then charge the pharmacy. timing of this may vary
            Charge.create!(pharmacy_id: pharmacy.id, batch_id: _batch_id)
            # find a way to notify all drivers besides this one, that the request is no longer valid
            Driver.notify_drivers_request_invalidated(driver, pharmacy, _batch_id)
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
