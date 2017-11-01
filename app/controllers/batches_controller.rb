class BatchesController < ApplicationController
  skip_before_action :verify_authenticity_token
  
  def new
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
  
  # add a few patients (up to 10 per batch)
  # def add_patient
  #   @patient = Patient.new(patient_params)
  #   respond_to do |format|
  #     if @patient.save
  #       format.js {render layout: false}
  #     end
  #   end
  # end
  
  # initiate a request for a local driver
  def request_driver
    @batch = Batch.find_by(id: params[:id])
    @patients = @batch.patients
    @pharmacy = current_pharmacy
    # create the request into database
    @request = Request.create!(pharmacy_id: @pharmacy.id, pharmacy: @pharmacy, patients: @patients, batch_id: @batch.id, count: 0, status: 'pending')
    # initiate the request
    @initial_request = Request.initiate_request(@batch.id, @patients, @pharmacy)
    Request.send_request(@batch.id, @pharmacy, @initial_request, @request) # send requests to drivers
    respond_to do |format|
      format.js {render layout: false}
    end
  end
  
  def driver_response
    # retrieve message details
    url = request.original_url
    if url.include?('From') && url.include?('Body')
      num_start = url.index('From') + 5
      body_start = url.index('Body') + 5
      number = url[num_start..num_start + 11]
      request_response = url[body_start + 4]
    end
    # params_hash = CGI::parse(URI.parse(url).query)
    directions = "Thank you for accepting this request. Your pickup is now ready at #{pharmacy.name}.\n
                        For verification purposes, present your ID once you arrive.\nTo cancel this pickup, reply 'cancel'."
    number = params['From']
    request_response = params['Body']
    boot_twilio
    @client.api.account.messages.create(
                    from: '+13474640621',
                    to: number,
                    body: directions
                )
    # if number && request_response
    #   # fetch the original message sent to drivers. driver number is used since we delete every message we sent to drivers to avoid clogging
    #   initial_request_message = RequestMessage.find_by(driver_number: number).message_body
    #   # pharmacy is looked up
    #   pharmacy = Pharmacy.find_by(id: initial_request_message.pharmacy_id)
    #   # figure out the details of the initial request
    #   initial_request = Request.find_by(body: initial_request_message)
    #   # decide what to do depending on the driver's response
    #   if request_response == 'yes'
    #     # if the response is 'yes', update the initial request
    #     Request.find_by(id: initial_request.id).update!(status: 'accepted', count: count + 1)
    #     # send directions to driver, notify other drivers
    #     Batch.respond_to_drivers(number, pharmacy, request_responses, initial_request_message, initial_request, initial_request.batch_id)
    #   elsif request_response == 'can'
    #     # this response means a driver previously accepted a request, and is now cancelling
    #     # so we first fetch the driver
    #     driver = Driver.find_by(number: number)
    #     # then the initial request
    #     initial_request = Request.find_by(driver: driver, status: 'accepted', body: initial_request_message)
    #     # update request to show pending status, and reset count to 0
    #     initial_request.update!(status: 'pending', count: 0)
    #     # resend the request to all but the cancelling driver
    #     Request.resend_request(initial_request.batch_id, initial_request.pharmacy, initial_request, driver)
    #   end
    # end
  end

  def destroy
  end
  
  private
  
    def boot_twilio
      account_sid = 'AC7b0eae323dc72522bb616648567a7de6'
      auth_token = '2a27c125b10a4429e8a24ccd08584670'
      @client = Twilio::REST::Client.new account_sid, auth_token
    end
    
    def batch_params
      params.fetch(:batch, {}).require(:notes)
    end
    
end
