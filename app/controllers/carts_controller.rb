class CartsController < ApplicationController
  
  before_action :check_empty, only: [:show]
  before_action :check_completed, only: [:confirmation]
  
  def show
    @cart = Cart.find_by(shopper_email: guest_shopper.email)
  end
  
  def confirmation
  end
  
  def track_order_status
    order = params[:order_number]
    @order = Order.find_by(confirmation: order)
    if @order.nil?
      @status = 'not found'
      @text = 'We were unable to find this order.'
      render :layout => false
      return
    end
    case @order.status
    when 'pending'
      @status = 'received'
      @text = 'Your order has been received by the store!'
    when 'ready for delivery'
      @status = 'ready'
      @text = 'Your order has been prepared and is pending delivery!'
    when 'ready for pickup'
      @status = 'ready'
      @text = 'Your order is ready for pickup!'
    when 'picked up'
      @status = 'picked up'
      @text = 'You have picked up your order!'
    when 'delivered'
      @status = 'in transit'
      @text = 'Your delivery is on the way!'
    when 'cancelled'
      @status = 'cancelled'
      @text = "Your order has been cancelled. Please contact us if you haven't received a refund"
    else
      @status = 'no status'
      @text = "Please contact the store at #{Pharmacy.find_by(id: @order.pharmacy_id).number}."
    end
    render :layout => false
  end
  
  def add_item
    cart = params[:cart]
    cart[:item_instructions].blank? ? instructions = 'none' : instructions = cart[:item_instructions]
    @item = Item.find_by(id: cart[:item_id])
    @cart = Cart.find_by(shopper_email: cart[:temp_id])
    @cart.add_item(cart[:item_id], cart[:item_count], instructions)
    @cart.calculate_tip(@cart.tip)
  end
  
  def remove_item
    cart = params[:cart]
    item_id = cart[:item_id]
    @item = Item.find_by(id: cart[:item_id])
    @cart = Cart.find_by(shopper_email: cart[:temp_id])
    @total = @cart.total(@item)
    @cart.remove_item(item_id)
    @cart.calculate_tip(@cart.tip)
  end
  
  def clear_cart
    @cart = Cart.find_by(shopper_email: params[:cart][:shopper_email])
    @cart.clear_cart
    render :layout => false
  end
  
  def process_payment
    guest = guest_shopper.email
    if guest != params[:cart][:guest_shopper] || params[:cart][:stripeToken].blank? || params[:cart][:stripeToken].nil?
      @error = 'There seems to be some information mismatch. Please try again'
      render :layout => false
      return
    end
    @error = ''
    begin
      @cart = Cart.find_by(shopper_email: params[:cart][:guest_shopper])
      email = params[:cart][:email]
      full_address = params[:cart][:fullAddress]
      phone = params[:cart][:phone]
      apt_num = params[:cart][:aptNum]
      delivery_option = params[:cart][:deliveryOption]
      @cart.process_payment(params[:cart][:stripeToken], full_address, phone, apt_num, email, delivery_option)
      @order = Order.find_by(cart_id: @cart.id)
      # @referral = Referral.create(order_id: @order.id, code: rand(10000000..99999999), purchase_confirmation: @order.confirmation, generated_on: Time.zone.now)
    rescue
      @error = 'An error occured while processing this payment. Please try again'
    end
    pusher.trigger('new-rx', 'rx-request', {
      message: "New order!",
      id: @order.id,
      type: 'OTC',
      pharmacy_id: @order.pharmacy_id
    })
    @pharmacy = Pharmacy.find_by(id: @order.pharmacy_id)
    message = "Thank you for ordering on RxCarriers! Your request has been received by #{@pharmacy.name} and will be processed soon!"
    TwilioPatient.alert_customer(phone, message)
    PharmacyMailer.order_in_process(@order).deliver_now
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
  
  def calculate_tip
    data = params[:data]
    tip = data[:tip]
    return if tip.nil?
    @cart = Cart.find_by(shopper_email: guest_shopper.email)
    @cart.calculate_tip(tip)
    render :layout => false
  end
  
  def initiate_in_store_sale
    @cart = Cart.find_by(pharmacy_id: current_pharmacy.id, pending: true, completed: false, online: false)
    if @cart.nil?
      Cart.create(pharmacy_id: current_pharmacy.id, pending: true, completed: false, item_list: '', item_list_count: '', instructions_list: '', online: false)
    end
    render :layout => false
  end
  
  private
  
  def cart_params
    params.require(:cart).permit(:item_list, :item_list_count, :instructions_list, :shopper)
  end
  
  def check_completed
    @cart = Cart.find_by(id: params[:cart_id])
    @order = Order.find_by(confirmation: params[:confirmation_number])
    redirect_to :back if @cart.nil? || @order.nil?
    if @cart.completed == false || @cart.completed.nil?
      redirect_to "#{@cart.get_pharmacy.url}"
    end
  end
  
  def check_empty
    @cart = Cart.find_by(shopper_email: guest_shopper.email)
    if @cart.nil? || @cart.is_empty?
      redirect_to root_path, notice: 'You have not added any item to your cart yet'
    end
  end
end
