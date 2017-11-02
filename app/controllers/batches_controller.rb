class BatchesController < ApplicationController
  skip_before_action :verify_authenticity_token
  
  def new
    @batch = Batch.new
  end
  
  # create a new batch
  def create
    @batch = Batch.new(batch_params)
    respond_to do |format|
      if @batch.save
        format.js {render layout: false}
      end
    end
  end
  
  # initiate a request for a local driver
  def request_driver
    @batch = Batch.find_by(id: params[:id])
    @patients = @batch.patients
    @pharmacy = current_pharmacy
    # create the request into database
    @request = Request.create!(pharmacy_id: @pharmacy.id, batch_id: @batch.id, count: 0, status: 'pending')
    # initiate the request
    @request_details = Request.initiate_request(@batch.id, @patients, @pharmacy)
    Request.send_request(@batch.id, @pharmacy, @request_details, @request) # send requests to drivers
    respond_to do |format|
      format.js {render layout: false}
    end
  end
  
  def driver_response
    from = params['From']
    request_response = params['Body'].downcase
    @driver = Driver.find_by(number: from)
    directions = "Thank you for accepting, #{@driver.first_name}. Your pickup is now ready at #{pharmacy.name}.\nFor verification purposes, present your ID once you arrive.\nTo cancel this pickup, reply 'cancel'."
    initialize_twilio
    count = 0
    count += 1
    if request_response == 'yes'
      if count == 1
        initial_request_message = RequestMessage.where(driver_number: from, driver: nil).last
        pharmacy = Pharmacy.find_by(id: initial_request_message.pharmacy_id)
        new_request = Request.where(body: initial_request_message.message_body, pharmacy_id: pharmacy.id, driver: nil, count: 0).last
        counter = new_request.count
        counter += 1
        Request.find(new_request.id).update!(status: 'accepted', count: counter)
        new_request = Request.find(new_request.id)
        if new_request.count == 1
          @client.api.account.messages.create(
                  from: '+13474640621',
                  to: from,
                  body: directions
              )
          Request.find(new_request.id).update!(driver: @driver.number)
          Driver.notify_drivers_request_invalidated(@driver)
          RequestMessage.find(id: initial_request_message.id).update!(driver: @driver.number)
        end
      end
    elsif request_response == 'cancel pickup'
      initial_request_message = RequestMessage.where(driver_number: from, driver: @driver.number).last
      unless initial_request_message.nil?
        pharmacy = Pharmacy.find_by(id: initial_request_message.pharmacy_id)
        initial_request = Request.where(driver: @driver.number, status: 'accepted', body: initial_request_message.message_body).last
        Request.find(initial_request.id).update!(status: 'pending', count: 0, driver: nil)
        Request.resend_request(initial_request.batch_id, pharmacy, initial_request, @driver)
        RequestMessage.find(id: initial_request_message.id).update!(driver: @driver.number)
      end
    end
  end

  def destroy
  end
  
  private
  
    def initialize_twilio
      account_sid = 'AC7b0eae323dc72522bb616648567a7de6'
      auth_token = '2a27c125b10a4429e8a24ccd08584670'
      @client = Twilio::REST::Client.new account_sid, auth_token
    end
    
    def batch_params
      params.fetch(:batch, {}).require(:notes)
    end
    
end
