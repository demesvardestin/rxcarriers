class BatchesController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :authenticate_pharmacy!, except: [:home, :notifications]
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
    @batches = Batch.where(pharmacy_id: @pharmacy.id)
    if @batch.driver_id
      @courier = Driver.find(@batch.driver_id.to_i)
    end
    @id = @batches.index(@batch) + 1
  end
  
  def index
    @batches = Batch.where(pharmacy_id: current_pharmacy.id, deleted: false).all
    @patients = Patient.where(pharmacy_id: current_pharmacy.id).all
    @pharmacy = current_pharmacy
  end
  
  def create_batch
    pharmacist = params["pharmacist"].split('_').join(' ').titleize
    @batch = Batch.create(pharmacy_id: current_pharmacy.id, request_status: 'pending',
                          pharmacist: pharmacist, request_mileage: 0, request_cost: 0,
                          delivery_duration: 0, deleted: false)
    respond_to do |format|
      format.html {redirect_to @batch}
    end
  end
  
  def cancel_request
    id = params[:id]
    @batch = Batch.find(id)
    @batch.update(cancelled: true, request_status: 'cancelled', request_id: nil)
    render :layout => false
  end
  
  def update_batch
    request_id = params["request_id"]
    batch_id = params["batch_id"]
    @batch = Batch.find(batch_id)
    if @batch.pharmacy_id != current_pharmacy.id
      return
    end
    @batch.deliveries.each {|d| d.update(request_sent: true, request_sent_on: DateTime.now, completed: false) }
    @batch.update(request_id: request_id, deliveries_completed: 0, request_sent_on: DateTime.now)
    render :layout => false
  end
  
  def mark_picked
    id = params["id"].to_i
    @batch = Batch.find(id)
    @batch.update_status('picked')
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
    if @delivery.deliverable.request_id != nil
      return
    end
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
    batch_id = params['batch_id'].to_i
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
    batch_id = params['batch_id'].to_i
    driver_id = params['driver_id'].to_i
    @courier = Driver.find_by(driver_id)
    @batch = Batch.find_by(batch_id)
    if @courier.nil? || @batch.nil?
      return
    end
    @batch.update(driver_id: driver_id)
    @batch.update_status('accepted')
    @batch.deliveries.each {|b| b.update(driver_id: driver_id)}
    
    # trigger on 'my-channel' an event called 'my-event' with this payload:
    pusher.trigger('my-channel', 'my-event', {
        message: "Courier #{@courier.first_name} has accepted your request for batch # #{batch_id}"
    })
    render :layout => false
  end
  
  def pusher
    return Pusher::Client.new(
      app_id: "521090",
      key: "6b4730083f66596ec97e",
      secret: "95a0a2107ac2e620e46a",
      cluster: 'us2'
    )
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
    @batches = Batch.where(pharmacy_id: current_pharmacy.id, deleted: false).search(params[:search])
    render :layout => false
  end
  
  def driver_response
    from = params['From']
    request_response = params['Body'].downcase
    Batch.parse_response(from, request_response)
  end
  
  def order_asc
    @batches = Batch.where(pharmacy_id: current_pharmacy.id, deleted: false).all.order('created_at ASC')
    respond_to do |format|
      format.js {}
    end
  end
  
  def order_desc
    @batches = Batch.where(pharmacy_id: current_pharmacy.id, deleted: false).all.order('created_at DESC')
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
    @batch.update(deleted: true)
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
