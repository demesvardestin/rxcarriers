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
    directions = "Thank you for accepting this request. Your pickup is now ready at MedCab.\nFor verification purposes, present your ID once you arrive.\nTo cancel this pickup, reply 'cancel'."
    number = params['From']
    request_response = params['Body'].downcase
    initial_request_message = RequestMessage.find_by(driver_number: number)
    pharmacy = Pharmacy.find_by(id: initial_request_message.pharmacy_id)
    initial_request = Request.find_by(body: initial_request_message.message_body)
    initialize_twilio
    if request_response == 'yes'
      initial_request.update!(status: 'accepted', count: count + 1)
      if initial_request.count == 1
        @client.api.account.messages.create(
                from: '+13474640621',
                to: number,
                body: directions
            )
        driver = Driver.find_by(phone_number: number)
        Driver.notify_drivers_request_invalidated(driver, pharmacy, batch_id)
        initial_request.update!(delivery_driver: driver)
      end
    elsif request_response == 'can'
      driver = Driver.find_by(number: number)
      initial_request = Request.find_by(driver: driver, status: 'accepted', body: initial_request_message)
      initial_request.update!(status: 'pending', count: 0)
      Request.resend_request(initial_request.batch_id, initial_request.pharmacy, initial_request, driver)
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
