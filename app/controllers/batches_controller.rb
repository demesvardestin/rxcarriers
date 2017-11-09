class BatchesController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :authenticate_pharmacy!, except: [:new]
  before_filter :load_patable, only: [:show]
  
  def new
    @batch = Batch.new
  end
  
  def show
    @batch = Batch.find(params[:id])
    @patient = @patable.patients.new
    @patients = @patable.patients.all
  end
  
  def index
    @batches = Batch.where(pharmacy_id: current_pharmacy.id).all
  end
  
  # create a new batch
  def create
    @batch = Batch.new(batch_params)
    @batch.pharmacy = current_pharmacy
    respond_to do |format|
      if @batch.save
        format.html {redirect_to @batch}
        format.js {render layout: false}
      end
    end
  end
  
  # initiate a request for a local driver
  def request_driver
    @batch = Batch.find(params[:id])
    @patients = @batch.patients
    @pharmacy = current_pharmacy
    # create the request into database
    @request = Request.create!(pharmacy_id: @pharmacy.id, batch_id: @batch.id, count: 0, status: 'pending')
    # initiate the request
    Request.send_request(@request)
    redirect_to batches_path
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
          Driver.clock_in(@driver)
        when 'clock out'
          Driver.clock_out(@driver)
        else
          Driver.raise_error(@driver)
      end
  end

  def destroy
  end
  
  private
    
    # Patient load
    def load_patable
      resource, id = request.path.split('/')[1, 2]
      @patable = resource.singularize.classify.constantize.find(id)
    end
    
    def batch_params
      params.require(:batch).permit(:notes)
    end
    
end
