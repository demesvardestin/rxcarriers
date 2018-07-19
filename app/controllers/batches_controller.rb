class BatchesController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :authenticate_pharmacy!, except: [:home, :notifications, :delivery]
  before_filter :load_deliverable, only: [:show]
  before_action :check_current_pharmacy, only: [:new, :index, :create, :request_driver, :destroy]
  before_action :check_authenticated, only: [:show]
  
  def home
    
  end
  
  def new
    @batch = Batch.new
  end
  
  def index
    @batches = Batch.where(pharmacy_id: current_pharmacy.id, deleted: false, delivered: false).all
    @rx = Rx.new
  end
  
  def history
    @batches = Batch.where(pharmacy_id: current_pharmacy.id, deleted: false, delivered: true).all
  end
  
  def get_quote
    @batch = Batch.find_by(id: params[:batch_id])
    @quote = Batch.quote(@batch)
    @batch.update(quote_id: @quote.id, quote_price: @quote.fee)
    render :layout => false
  end
  
  def remove_rx
    rx_id = params[:rx_id]
    batch_id = params[:batch_id]
    @batch = Batch.find_by(id: batch_id)
    @rx = Rx.find_by(id: rx_id, batch_id: batch_id)
    @rx.delete
    render :layout => false
  end
  
  def request_courier
    @batch = Batch.find_by(id: params[:batch_id])
    @delivery = Batch.request_courier(@batch)
    @batch.update(delivery_id: @delivery.id, courier_requested: true, requested_at: DateTime.now)
    render :layout => false
  end
  
  def cancel_courier_request
    @batch = Batch.find_by(id: params[:batch_id])
    @cancel = Batch.cancel_courier(@batch)
    @batch.update(delivery_id: nil, courier_requested: false, requested_at: nil)
    render :layout => false
  end
  
  def delivery
    @event = params
    @batch = Batch.find_by(delivery_id: @event[:delivery_id])
    # status = @batch.status
    if @event[:kind] == 'event.courier_update'
      render :layout => false
      return
    end
    if !@event[:status].nil?
      case @event[:status]
      when 'pickup'
        status = 'pickup in progress'
      when 'pickup_complete'
        status = 'pickup completed'
      when 'dropoff'
        status = 'delivery in progress'
      when 'delivered'
        status = 'delivery completed'
      else
        status = @batch.status
      end
    else
      status = @batch.status
    end
    if !@event[:data][:courier].nil?
      @courier = @event[:data][:courier]
      @batch.update(
        courier_name: @courier[:name],
        courier_rating: @courier[:rating],
        courier_vehicle_type: @courier[:vehicle_type],
        courier_phone_number: @courier[:phone_number],
        courier_avatar: @courier[:img_href],
        status: status,
        tracking_url: @event[:data][:tracking_url]
      )
    end
    pusher.trigger('new-rx', 'rx-request', {
      message: "Request accepted",
      id: @batch.id,
      status: status,
      pharmacy_id: @batch.pharmacy_id
    })
    render :layout => false
  end
  
  def delivery_update
    status = params[:status]
    @batch = Batch.find_by(id: params[:batch_id])
    if !status.nil?
      @batch.update(status: status)
    end
    render :layout => false
  end
  
  # PERHAPS WE WILL USE THIS LATER
  # def fetch_details
  #   id = params[:id]
  #   @batch = Batch.find_by(id: id)
    
  #   return unless !@batch.nil?
  #   render :layout => false
  # end
  
  def pusher
    return Pusher::Client.new(
      app_id: "521090",
      key: "6b4730083f66596ec97e",
      secret: "95a0a2107ac2e620e46a",
      cluster: 'us2'
    )
  end
  
  def create_rx
    @batch = Batch.find_by(id: params[:id])
    @rx = Rx.new(rx_params)
    @rx.batch = @batch
    if @rx.save
      respond_to do |format|
        format.js {render :layout => false}
      end
    end
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
    id = params[:id]
    @batch = Batch.find(id)
    @batches = Batch.where(pharmacy_id: @batch.pharmacy_id, delivered: false, deleted: false)
    @batch.update(delivered: true)
    respond_to do |format|
      format.js {render :layout => false}
    end
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
    @rx = Rx.new
    @batch = Batch.new(batch_params)
    @batch.pharmacy = current_pharmacy
    @batch.auto_id = Batch.generate_id.to_s
    @batch.deleted = false
    @batch.delivered = false
    @batch.status = 'initialized'
    respond_to do |format|
      if @batch.save
        # format.html {redirect_to @batch}
        format.js {render layout: false}
      end
    end
  end
  
  def update
    @batch = Batch.find_by(id: params[:id])
    @batch.update(batch_params)
    respond_to do |format|
      format.js {render layout: false}
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
  
  def test_
    render :layout => false
  end

  def destroy
    @batch = Batch.find(params[:id])
    @batches = Batch.where(pharmacy_id: @batch.pharmacy_id, delivered: false, deleted: false)
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
      params.require(:batch).permit(:address, :phone_number)
    end
    
end
