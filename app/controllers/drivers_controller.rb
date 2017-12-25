class DriversController < ApplicationController
  before_action :authenticate_driver!
  before_action :check_driver
  
  def deliveries
    @deliveries = Request.where(driver: current_driver.number).all
    @batch = Batch.find(params[:id])
  end
  
  def clock_in
    @driver = current_driver
    @driver.update(clocked_in: true)
    redirect_to :back
  end
  
  def clock_out
    @driver = current_driver
    @driver.update(clocked_in: false)
    redirect_to :back
  end
  
  def transactions
    @driver = current_driver
    @batches = Batch.where(driver: @driver.number, request_status: 'completed').order("created_at DESC")
    @account = Stripe::Account.retrieve("#{@driver.stripe_uid.to_s}") if @driver.stripe_uid.present?
    @balance = Stripe::Balance.retrieve()
  end
  
  def payouts
    redirect_to :back
  end
  
  def requests
    @all_batches = Batch.where(driver: current_driver.number, request_status: 'accepted').all
    if current_driver.onboarding_complete
      @all_batches = Batch.where(driver: current_driver.number, request_status: 'accepted').all
      if @all_batches.empty?
        render 'not_found'
      end
    elsif current_driver.onfido_created.nil?
      render 'onfido'
    elsif current_driver.registration_completed.nil?
      render 'supports/settings'
    elsif current_driver.onboarded.nil?
      redirect_to welcome_path
      # render 'supports/onboarding_home', notice: 'Your profile has been updated!'
    end
  end
  
  def history
    @batches = Batch.where(driver: current_driver.number, request_status: 'completed')
    if @batches.empty?
      render 'not_found'
    end
  end
  
  def payments
    @driver = current_driver
  end
  
  def first_time
    @driver = current_driver
    if @driver.onboarding_complete || @driver.onfido_created.nil?
      redirect_to root_path
    end
  end
  
  def edit
    @driver = current_driver
  end
  
  def create
    @driver = Driver.new(driver_params)
    respond_to do |format|
      if @driver.save
        format.html { redirect_to @driver, notice: 'Driver was successfully created.' }
        format.json { render :show, status: :created, location: @driver }
      else
        format.html { render :new }
        format.json { render json: @driver.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def update
    @driver = current_driver
    if @driver.onfido_created.nil? && @driver.registration_completed.nil?
      @driver.update(
        :onfido_created => true,
        :first_name => params[:driver][:first_name],
        :last_name => params[:driver][:last_name],
        :dob => params[:driver][:dob],
        :gender => params[:driver][:gender],
        :number => params[:driver][:number]
      )
      redirect_to complete_profile_path, notice: @driver.notice
      return
    end
    respond_to do |format|
      if @driver.update(driver_params)
        @driver.update_onboarding
        if @driver.onboarding_complete
          format.html { redirect_to :back, notice: 'Your profile has been updated!' }
        elsif @driver.stripe_token.nil?
          format.html { redirect_to payment_path, notice: @driver.notice }
        elsif @driver.registration_completed == true
          format.html { redirect_to welcome_path, notice: @driver.notice }
        else
          format.html { redirect_to root_path, notice: 'Your profile has been updated!' }
        end
        format.json { render :show, status: :ok, location: @driver }
      else
        format.html { render :edit }
        format.json { render json: @driver.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def destroy
    @driver = Driver.find(params[:id])
    @driver.destroy
    respond_to do |format|
      format.html { redirect_to drivers_url, notice: 'Driver was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    
    def redirect_new_driver
      redirect_to root_path if current_driver && current_driver.onfido_created.nil?
    end
    
    # make sure the correct driver is authed
    def check_driver
      @driver = current_driver
      redirect_to unauthorized_path, notice: "Not authorized to access this page" if @driver.nil?
    end
    
    # params whitelist
    def driver_params
      params.require(:driver).permit(:first_name, :last_name, :number, :street, :town, :state, :zipcode, :license_plate, :car_make, 
                                      :car_model, :car_year, :car_color, :avatar, :dob, :gender, :middle_name)
    end
end
