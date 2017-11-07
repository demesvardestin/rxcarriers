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
      case request_response
      when 'yes'
        Batch.respond_to_driver(@driver)
      when 'cancel pickup'
        Batch.cancel_driver(@driver)
      when 'completed'
        Batch.delivery_completed(@driver)
      when 'clock in'
        @driver.update!(clocked_in: true)
      when 'clock out'
        @driver.update!(clocked_in: false)
      else
        Driver.raise_error(@driver)
      end
  end

  def destroy
  end
  
  private
    
    def batch_params
      params.fetch(:batch, {}).require(:notes)
    end
    
end
