class Batch < ActiveRecord::Base
    
    belongs_to :pharmacy
    has_many :patients, :as => :patable
    
    def self.respond_to_driver(driver)
        Batch.initialize_twilio
        @initial_request_message = RequestMessage.where(driver_number: driver.number, driver: nil).last
        @pharmacy = Pharmacy.find(@initial_request_message.pharmacy_id)
        directions = "Thank you for accepting, #{driver.first_name}. Your pickup is now ready at #{@pharmacy.name}.\nFor verification purposes, present your ID once you arrive.\nTo cancel this pickup, reply 'cancel pickup'."
        @new_request = Request.where(body: @initial_request_message.message_body, pharmacy_id: @pharmacy.id, driver: nil, count: 0).last
        counter = @new_request.count
        counter += 1
        @new_request.update!(status: 'accepted', count: counter)
        if @new_request.count == 1
            @client.api.account.messages.create(
                    from: '+13474640621',
                    to: driver.number,
                    body: directions
                )
            @client.api.account.messages.list(
                    from: '+13474640621',
                    to: driver.number
                ).each do |message|
                   message.delete 
                end
            @new_request.update!(driver: driver.number)
            Driver.notify_drivers_request_invalidated(driver)
        end
    end
    
    def self.cancel_driver(driver)
        Batch.initialize_twilio
        @initial_request_message = RequestMessage.where(driver_number: driver.number, driver: driver.number).last
        unless @initial_request_message.nil?
            @pharmacy = Pharmacy.find(@initial_request_message.pharmacy_id)
            @initial_request = Request.where(driver: driver.number, status: 'accepted', body: @initial_request_message.message_body).last
            @initial_request.update!(status: 'pending', count: 0, driver: nil)
            Request.resend_request(@initial_request.batch_id, @pharmacy, @initial_request, driver)
            @initial_request_message.update!(driver: nil)
        end 
    end
    
    def self.initialize_twilio
        account_sid = 'AC7b0eae323dc72522bb616648567a7de6'
        auth_token = '2a27c125b10a4429e8a24ccd08584670'
        @client = Twilio::REST::Client.new account_sid, auth_token
    end
    
end