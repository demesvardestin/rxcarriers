class BatchesController < ApplicationController
  skip_before_action :verify_authenticity_token
  # before_action :authenticate_pharmacy!, except: [:new]
  before_filter :load_deliverable, only: [:show]
  
  def new
    @batch = Batch.new
  end
  
  def show
    @batch = Batch.find(params[:id])
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
    @requests = Request.where(pharmacy_id: current_pharmacy.id).all
    @patients = Patient.where(pharmacy_id: current_pharmacy.id).all
    @chosen_patient = nil
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
    @packages = @batch.packages
    @pharmacy = current_pharmacy
    @request = Request.create!(pharmacy_id: @pharmacy.id, batch_id: @batch.id, count: 0, status: 'pending')
    Request.send_request(@request)
    redirect_to :back, notice: "Request Sent. Check the requests page for status updates."
  end
  
  def driver_response
      from = params['From']
      request_response = params['Body'].downcase
      Batch.parse_response(from, request_response)
  end

  def destroy
    @batch = Batch.find(params[:id])
    @batch.destroy
    respond_to do |format|
      format.html { redirect_to batches_path, notice: 'Batch was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  
  private
    
    # Delivery package load
    def load_deliverable
      resource, id = request.path.split('/')[1, 2]
      @deliverable = resource.singularize.classify.constantize.find(id)
    end
    
    def batch_params
      params.require(:batch).permit(:notes, :pharmacist)
    end
    
end
