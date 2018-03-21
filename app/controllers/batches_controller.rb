class BatchesController < ApplicationController
  skip_before_action :verify_authenticity_token
  # before_action :authenticate_pharmacy!, except: [:new]
  before_filter :load_deliverable, only: [:show]
  before_action :check_current_pharmacy, only: [:new, :index, :create, :request_driver, :destroy]
  before_action :check_authenticated, only: [:show]
  
  def home
    
  end
  
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
    @batches = Batch.where(pharmacy_id: current_pharmacy.id).all
    @patients = Patient.where(pharmacy_id: current_pharmacy.id).all
    @pharmacy = current_pharmacy
  end
  
  def create_batch
    pharmacist = params["pharmacist"].split('_').join(' ').titleize
    @batch = Batch.create(pharmacy_id: current_pharmacy.id, request_status: 'pending',
                          pharmacist: pharmacist, request_mileage: 0, request_cost: 0,
                          delivery_duration: 0)
    respond_to do |format|
      format.html {redirect_to @batch}
    end
  end
  
  def update_batch
    request_id = params["request_id"]
    batch_id = params["batch_id"]
    @batch = Batch.find(batch_id)
    if @batch.pharmacy_id != current_pharmacy.id
      return
    end
    @batch.deliveries.each {|d| d.update(request_sent: true) }
    @batch.update(request_id: request_id)
    render :layout => false
  end
  
  def get_delivery_details
    @batch = Batch.find(params[:id])
    respond_to do |format|
      format.json {}
    end
  end
  
  def delete_delivery
    deliv_id = params[:id]
    @delivery = Delivery.find(deliv_id)
    @delivery.destroy
    respond_to do |format|
      format.js {}
    end
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
  
  def update_supervisor
    id = params["pharmacy_id"].to_i
    if id != current_pharmacy.id
      return
    end
    pharmacist = params["pharmacist"]
    @pharmacy = Pharmacy.find(id)
    @pharmacy.update(supervisor: pharmacist)
    @pharmacy_to_param = @pharmacy.supervisor.downcase.split(' ').join('_')
    respond_to do |format|
      format.js {}
    end
  end
  
  def create_deliveries
    id = params["patient_id"].to_i
    name = params["patient_name"]
    address = params['patient_address']
    phone = params['patient_phone']
    copay = params['copay']
    medications = params["medications"]
    batch_id = params['batch_id']
    time = params['delivery']
    @delivery = Delivery.create(
      recipient_name: name,
      recipient_address: address,
      recipient_phone_number: phone,
      medications: medications,
      copay: copay,
      time: time,
      deliverable_type: 'Batch',
      deliverable_id: batch_id,
      pharmacy_id: current_pharmacy.id,
      patient_id: id
    )
    @batch = Batch.find(batch_id)
    @pharmacy = Pharmacy.find(@batch.pharmacy_id)
    cost, mileage, duration = @batch.calculate_request_details(@batch)
    @batch.update(request_mileage: mileage, request_cost: cost, delivery_duration: duration)
    @deliveries = @batch.deliveries
    respond_to do |format|
      format.js {}
    end
  end
  
  def notifications
    batch_id = params['batch_id']
    Notification.create(batch_id: batch_id, pharmacy_id: current_pharmacy.id,
                        content: "Your request for batch # #{batch_id} has been accepted", read: false)
    @notifications = Notification.where(pharmacy_id: current_pharmacy.id, read: false)
    render :layout => false
  end
  
  def clear_notifications
    @notifications = Notification.where(pharmacy_id: current_pharmacy.id, read: false)
    @notifications.each do |n|
      n.update(read: true)
    end
    render :layout => false
  end
  
  def dismiss_notification
    @notification = Notification.find(params[:id])
    @notification.update(read: true)
    @notifications = Notification.where(pharmacy_id: current_pharmacy.id, read: false)
    respond_to do |format|
      format.js {}
    end
  end
  
  def batch_search
    @batches = Batch.where(pharmacy_id: current_pharmacy.id).search(params[:search])
    render :layout => false
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
  
  def erase
    @batch = Batch.find(params[:id])
    @batch.destroy
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
