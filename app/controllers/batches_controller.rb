class BatchesController < ApplicationController
  skip_before_action :verify_authenticity_token
  # before_action :authenticate_pharmacy!, except: [:new]
  before_filter :load_deliverable, only: [:show]
  before_action :check_current_pharmacy, only: [:new, :index, :create, :request_driver, :destroy]
  before_action :check_authenticated, only: [:show]
  
  def new
    @batch = Batch.new
  end
  
  def show
    @batch = Batch.find(params[:id])
    @pharmacy = Pharmacy.find(@batch.pharmacy_id)
    @batches = Batch.where(pharmacy_id: current_pharmacy.id)
    @id = @batches.index(@batch) + 1
    @delivery = @deliverable.deliveries.new
    @deliveries = @deliverable.deliveries.all
  end
  
  def index
    if params[:search]
      @batches = Batch.where(pharmacy_id: current_pharmacy.id).search(params[:search])
    else
      @batches = Batch.where(pharmacy_id: current_pharmacy.id).all
    end
    @batch = Batch.new
    @requests = Request.where(pharmacy_id: current_pharmacy.id).all
    @patients = Patient.where(pharmacy_id: current_pharmacy.id).all
    @chosen_patient = nil
  end
  
  def create_batch
    @batch = Batch.create(pharmacy_id: current_pharmacy.id, request_status: 'pending')
    respond_to do |format|
      format.html {redirect_to @batch}
    end
  end
  
  def update_batch
    request_id = params["request_id"]
    batch_id = params["batch_id"]
    Batch.find(batch_id).update(request_id: request_id)
    redirect_to :back
  end
  
  
  # create a new batch
  def create
    @batches = Batch.where(pharmacy_id: current_pharmacy.id).all
    @batch = Batch.new(batch_params)
    @batch.pharmacy = current_pharmacy
    @batch.batch_id = (@batches.count + 1)
    respond_to do |format|
      if @batch.save
        format.html {redirect_to @batch}
        format.js {render layout: false}
      end
    end
  end
  
  def batch_search
    @batches = Batch.where(pharmacy_id: current_pharmacy.id).search(params[:search])
    respond_to do |format|
      format.js {}
    end
  end
  
  # initiate a request for a local driver
  def request_driver
    @batch = Batch.find(params[:id])
    @pharmacy = current_pharmacy
    @request = Request.create!(pharmacy_id: @pharmacy.id, batch_id: @batch.batch_id, count: 0, status: 'pending')
    Request.send_request(@request)
    @batch.update(request_status: 'pending')
    redirect_to :back, notice: "Request Sent. Check the requests page for status updates."
  end
  
  def driver_response
    from = params['From']
    request_response = params['Body'].downcase
    Batch.parse_response(from, request_response)
  end
  
  def order_asc
    @batches = Batch.where(pharmacy_id: current_pharmacy.id).all.order('created_at ASC')
    respond_to do |format|
      format.js {}
    end
  end
  
  def order_desc
    @batches = Batch.where(pharmacy_id: current_pharmacy.id).all.order('created_at DESC')
    respond_to do |format|
      format.js {}
    end
  end

  def destroy
    @batch = Batch.find(params[:id])
    @batch.destroy
    respond_to do |format|
      format.js {}
    end
  end
  
  private
    
    # Delivery package load
    def load_deliverable
      resource, id = request.path.split('/')[1, 2]
      @deliverable = resource.singularize.classify.constantize.find(id)
    end
    
    def batch_params
      params.require(:batch).permit(:notes)
    end
    
end
