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
    Request.send_request(@request)
    respond_to do |format|
      format.js {render layout: false}
    end
  end
  
  def driver_response
      from = params['From']
      request_response = params['Body'].downcase
      @driver = Driver.find_by(number: from)
      initialize_twilio
      if request_response == 'yes'
        Batch.respond_to_driver(@driver)
      elsif request_response == 'cancel pickup'
        Batch.cancel_driver(@driver)
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
