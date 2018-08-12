class PharmaciesController < ApplicationController
  before_action :set_pharmacy, only: [:update, :destroy]
  before_action :check_current_pharmacy, except: [:home, :contact, :blog, :terms,
                :privacy, :press, :search, :search_pharmacy, :show, :create_review,
                :landing, :register_your_pharmacy, :submit_registration_request]
  before_action :check_parameters, only: [:show]
  
  def edit
    @pharmacy = current_pharmacy
  end
  
  def landing
    
  end
  
  def getting_started
    @ticket = HelpTicket.new
  end
  
  def notifications
    @notifications = Notification.where(pharmacy_id: current_pharmacy.id)
  end
  
  def fetch_notification
    notification = params[:notification]
    @notification = Notification.find_by(id: notification[:id])
    @notification.update(read: true)
    render :layout => false
  end
  
  def mark_read
    @notification = Notification.find_by(id: params[:id])
    @notification.update(read: true)
    render :layout => false
  end
  
  def show
    @review = Review.new
    @categories = ItemCategory.all
  end
  
  def analytics
    @pharmacy = current_pharmacy
    @inventory = @pharmacy.inventory
  end
  
  def analytics_weekly
    @pharmacy = current_pharmacy
    @inventory = @pharmacy.inventory
    render :layout => false
  end
  
  def analytics_monthly
    @pharmacy = current_pharmacy
    @inventory = @pharmacy.inventory
    render :layout => false
  end
  
  def analytics_annually
    @pharmacy = current_pharmacy
    @inventory = @pharmacy.inventory
    render :layout => false
  end
  
  def analytics_overall
    @pharmacy = current_pharmacy
    @inventory = @pharmacy.inventory
    render :layout => false
  end
  
  def create_review
    @pharmacy = Pharmacy.find_by(id: params[:id])
    @review = Review.new(review_params)
    respond_to do |format|
      if @review.save
        format.js {render 'create_review', :layout => false}
      else
        format.js {render 'review_error', :layout => false}
      end
    end
  end
  
  def create_item
    @pharmacy = current_pharmacy
    @item = Item.new(item_params)
    @item.pharmacy_id = current_pharmacy.id
    @item.inventory_id = current_pharmacy.inventory.id
    taxable = params[:item][:taxable].downcase
    if taxable == 'yes'
      tax = true
    else
      tax = false
    end
    @item.taxable = tax
    respond_to do |format|
      if @item.save
        @items = Item.where(pharmacy_id: current_pharmacy.id).sort_by(&:name)
        format.js {render 'create_item', :layout => false}
      else
        format.js {render 'item_error', :layout => false}
      end
    end
  end
  
  def update_item
    @item = Item.find_by(id: params[:id])
    @item.update(item_params)
    respond_to do |format|
      if @item.save
        @items = Item.where(pharmacy_id: current_pharmacy.id).sort_by(&:name)
        format.js {render 'update_item', :layout => false}
      else
        format.js {render 'item_error', :layout => false}
      end
    end
  end
  
  def remove_item
    @item = Item.find_by(id: params[:id])
    @item.destroy
    respond_to do |format|
        @items = Item.where(pharmacy_id: current_pharmacy.id).sort_by(&:name)
        format.js {render 'remove_item', :layout => false}
    end
  end
  
  def billing
    @pharmacy = current_pharmacy
  end
  
  def update_firebase
    firebase_id = params["firebase_id"]
    @pharmacy = current_pharmacy
    @pharmacy.update(firebase_id: firebase_id)
    redirect_to :back
  end
  
  def home
    
  end
  
  def press
    
  end
  
  def privacy
    
  end
  
  def terms
    
  end
  
  def blog
    
  end
  
  def contact
    
  end
  
  def add_card
    token = params['stripeToken']
    @pharmacy = current_pharmacy
    @plan = StripePlan.find_by(pharmacy_id: @pharmacy.id)
    @plan.name == 'beginner' ? plan = 'plan_D0YgQfwIKRVkjx' : plan = 'plan_D0Ygdw4uY8YinB'
    if @pharmacy.stripe_cus
      customer = Stripe::Customer.retrieve(@pharmacy.stripe_cus)
      customer.source = token
      customer.save
    else
      customer = Stripe::Customer.create(
        :email => @pharmacy.email,
        :source => token,
      )
    end
    subscription = Stripe::Subscription.create({
      customer: customer.id,
      items: [{plan: plan}],
      trial_period_days: 7,
    })
    @pharmacy.update(card_token: token, stripe_cus: customer.id, sub_auth: subscription.id)
    render :layout => false
  end
  
  def cancel_subscription
    subscription = Stripe::Subscription.retrieve(current_pharmacy.sub_auth)
    subscription.delete
    current_pharmacy.update(on_trial: false, is_subscribed: false, sub_auth: nil, sub_plan: nil, delinquent: false)
    redirect_to choose_subscription_path
  end
  
  def update_first_time
    sign_in_count = current_pharmacy.sign_in_count + 1
    current_pharmacy.update(sign_in_count: sign_in_count)
    render :layout => false
  end
  
  def search_pharmacy
    @param = params[:q]
    @pharmacies = Pharmacy.sort_search(@param)
    if @pharmacies == 'Invalid location'
      @invalid = @pharmacies
    end
    render :layout => false
  end
  
  def search
    @param = params[:q]
    @pharmacies = Pharmacy.sort_search(@param)
    if @pharmacies == 'Invalid location'
      @invalid = @pharmacies
    end
  end
  
  def dashboard
    @orders = Order.all.where(pharmacy_id: current_pharmacy.id, processed: false, status: 'pending', online: true).reverse
  end
  
  def in_store
    @cart = Cart.find_by(pharmacy_id: current_pharmacy.id, pending: true, completed: false, online: false)
    if @cart.nil?
      @cart = Cart.create(pharmacy_id: current_pharmacy.id, pending: true, completed: false, item_list: '', item_list_count: '', instructions_list: '', online: false, total_cost: '0.0')
    end
  end
  
  def register_your_pharmacy
    @registration = RegistrationRequest.new
  end
  
  def submit_registration_request
    @registration = RegistrationRequest.new(registration_params)
    respond_to do |format|
      if @registration.save
        format.js { render :layout => false }
      end
    end
  end
  
  def process_order
    @order = Order.find_by(id: params[:id])
    if @order.nil?
      render :layout => false, notice: 'There was a problem performing this action'
      return
    end
    @order.update(processed: true, status: 'processed', delivered: false)
    @orders = Order.all.where(pharmacy_id: current_pharmacy.id, processed: false, status: 'pending', online: true)
    ## TEXT CUSTOMER ORDER UPDATE
    render :layout => false
  end
  
  def cancel_order
    @order = Order.find_by(id: params[:id])
    if @order.nil?
      render :layout => false, notice: 'There was a problem performing this action'
      return
    end
    @order.update(processed: false, status: 'cancelled', delivered: false)
    Refund.create(
      amount: @order.total,
      order_id: @order.id,
      pharmacy_id: @order.pharmacy_id,
      completed: false,
      details: "Store initiated cancelling for order ##{@order.confirmation}",
      stripe_cus: @order.stripe_charge_id
    )
    ## TEXT CUSTOMER ORDER UPDATE
    render :layout => false
  end
  
  def send_for_delivery
    @order = Order.find_by(id: params[:id])
    if @order.nil?
      render :layout => false, notice: 'There was a problem performing this action'
      return
    end
    @order.update(processed: true, status: 'delivered', delivered: true)
    @orders = Order.all.where(pharmacy_id: current_pharmacy.id, delivered: false, status: 'processed')
    ## TEXT CUSTOMER ORDER UPDATE
    render :layout => false
  end
  
  def post_new_order
    @order = Order.find_by(id: params[:order][:id])
    @pharmacy = Pharmacy.find_by(id: params[:order][:pharmacy_id])
    return if @order.nil? || @pharmacy.nil?
    render :layout => false
  end
  
  def queue
    @pending_orders = Order.all.where(pharmacy_id: current_pharmacy.id, delivered: false, status: 'processed').reverse
    @delivered_orders = Order.all.where(pharmacy_id: current_pharmacy.id, delivered: true, status: 'delivered').reverse
  end
  
  def inventory
    @inventory = Inventory.find_by(pharmacy_id: current_pharmacy.id)
    if @inventory.nil?
      @inventory = Inventory.create(pharmacy_id: current_pharmacy.id)
    end
    @items = current_pharmacy.inventory.items.sort_by(&:name)
    @item = Item.new
  end
  
  def expiring_soon
    @items = Item.where('quantity > 0').expire_soon(current_pharmacy.id).sort_by(&:name)
    render :layout => false
  end
  
  def low_available_count
    @items = Item.low_available_count(current_pharmacy.id).sort_by(&:name)
    render :layout => false
  end
  
  def remove_filters
    @items = current_pharmacy.inventory.items.sort_by(&:name)
    render :layout => false
  end
  
  def search_item
    data = params[:data][:param].split("-").join('')
    if data.to_i != 0 && data.to_i.is_a?(Numeric)
      @items = current_pharmacy.inventory.items.match_ndc(data, current_pharmacy.id).sort_by(&:name)
    else
      @items = current_pharmacy.inventory.items.search(data).sort_by(&:name)
    end
    render :layout => false
  end
  
  def validate_presence
    data = params[:data][:param].split("-").join('')
    @items = Item.find_by_ndc(data, current_pharmacy.id)
    render :layout => false
  end
  
  def update_card
    token = params['stripeToken']
    @pharmacy = current_pharmacy
    if @pharmacy.stripe_cus
      customer = Stripe::Customer.retrieve(@pharmacy.stripe_cus)
      customer.source = token
      customer.save
    else
      customer = Stripe::Customer.create(
        :email => @pharmacy.email,
        :source => token,
      )
    end
    if customer.nil?
      redirect_to choose_subscription_path
    end
    @pharmacy.update(card_token: token, stripe_cus: customer.id)
    render :layout => false
  end
  
  def submit_agreement
    @terms_profile = TermsAndAgreement.find_by(pharmacy_id: params[:id])
    if @terms_profile.nil?
      @terms_profile = TermsAndAgreement.create(pharmacy_id: params[:id], signed: true, signed_on: Time.now)
    end
    current_pharmacy.update(is_subscribed: true, on_trial: true)
    render :layout => false
  end
  
  def create
    @pharmacy = Pharmacy.new(pharmacy_params)
    respond_to do |format|
      if @pharmacy.save
        format.html { redirect_to @pharmacy, notice: 'Pharmacy was successfully created.' }
        format.json { render :show, status: :created, location: @pharmacy }
      else
        format.html { render :new }
        format.json { render json: @pharmacy.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def update_profile
    name = params["name"]
    number = params["number"]
    supervisor = params["supervisor"]
    street = params["street"]
    town = params["town"]
    zipcode = params["zipcode"]
    state = params["state"]
    website = params["website"]
    avatar = params["avatar"]
    @pharmacy = current_pharmacy
    @pharmacy.update(pharmacy_params)
    respond_to do |format|
      format.js {}
    end
  end
  
  def store_push_endpoint
    @sub = JSON.parse(JSON.dump(params.fetch(:sub, {}))).with_indifferent_access
    endpoint = @sub["endpoint"]
    auth = @sub["keys"]["auth"]
    p256dh = @sub["keys"]["p256dh"]
    current_pharmacy.update(push_endpoint: endpoint, sub_auth: auth, p256dh: p256dh, subscribed_to_push: true)
  end
  
  def update
    @pharmacy.update(pharmacy_params)
    respond_to do |format|
      format.js { render 'pharmacies/update_profile', notice: 'Profile updated!' }
    end
  end
  
  def destroy
    @pharmacy.destroy
    respond_to do |format|
      format.html { redirect_to pharmacies_url, notice: 'Pharmacy was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_pharmacy
      @pharmacy = Pharmacy.find(params[:id])
    end
    
    def check_parameters
      name = params[:name]
      id = params[:id]
      if name.blank? || id.blank?
        redirect_to :back
      end
      @pharmacy = Pharmacy.find_by(id: id)
      if @pharmacy.nil?
        redirect_to :back
      end
      if params[:q]
        distance = @pharmacy.unslug(params[:q])
      else
        distance = request.location.latitude.to_s + ', ' + request.location.longitude.to_s
      end
      @distance = @pharmacy.distance_to(distance)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def item_params
      params.require(:item).permit(:name, :price, :quantity, :details, :size, :size_type, :ndc, :expiration, :item_category_id)
    end
    
    def registration_params
      params.require(:registration_request).permit(:pharmacy_name, :pharmacy_email, :pharmacy_address, :pharmacy_phone, :pharmacy_manager, :pharmacy_website)
    end
    
    def pharmacy_params
      params.require(:pharmacy).permit(:name, :street, :number, :supervisor, :website, :card_number, 
      :town, :state, :zipcode, :avatar, :hours, :delivers)
    end
end
