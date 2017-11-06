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
      first_sample = ['yes', 'yea', 'yep', 'yas', 'yess']
      second_sample = ['cancel', 'cancel pickup', 'cancell', 'cancel pickupp']
      third_sample = ['completed', 'delivery completed', 'completed delivery', 'delivery complete']
      @driver = Driver.find_by(number: from)
      if first_sample.include?(request_response)
        Batch.respond_to_driver(@driver)
      elsif second_sample.include?(request_response)
        Batch.cancel_driver(@driver)
      elsif third_sample.include?(request_response)
        Batch.delivery_completed(@driver)
      end
  end

  def destroy
  end
  
  private
    
    def batch_params
      params.fetch(:batch, {}).require(:notes)
    end
    
end
