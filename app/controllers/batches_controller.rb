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
      request_response = url[body_start..body_start + 4]
    end
    if number && request_response
      initial_request_message = RequestMessage.find_by(driver_number: number)
      pharmacy = Pharmacy.find_by(id: initial_request_message.pharmacy_id)
      initial_request = Request.find_by(body: initial_request_message.message_body)
      if request_response == 'yes'
        initial_request.update!(status: 'accepted', count: count + 1)
        Batch.respond_to_drivers(number, pharmacy, initial_request, initial_request.batch_id)
      elsif request_response == 'can'
        driver = Driver.find_by(number: number)
        initial_request = Request.find_by(driver: driver, status: 'accepted', body: initial_request_message)
        initial_request.update!(status: 'pending', count: 0)
        Request.resend_request(initial_request.batch_id, initial_request.pharmacy, initial_request, driver)
      end
    end
  end

  def destroy
  end
  
  private
    
    def batch_params
      params.fetch(:batch, {}).require(:notes)
    end
    
end
