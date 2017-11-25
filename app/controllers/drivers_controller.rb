class DriversController < ApplicationController
  before_action :set_driver, only: [:edit, :update, :destroy]
  before_action :authenticate_driver!
  before_action :check_driver

  # GET /drivers
  # GET /drivers.json
  def index
    @drivers = Driver.all
  end

  # GET /drivers/1
  # GET /drivers/1.json
  def show
  end

  # GET /drivers/new
  def new
    @driver = Driver.new
  end
  
  def deliveries
    if current_driver.driver_approved
      @deliveries = Request.where(driver: current_driver.number).all
    else
      if current_driver.registration_completed
        redirect_to home_path
      else
        redirect_to edit_driver_path(current_driver)
      end
    end
  end
  
  def transactions
    @driver = current_driver
    @account = Stripe::Account.retrieve("#{@driver.stripe_uid.to_s}") if @driver.stripe_uid.present?
    @balance = Stripe::Balance.retrieve() if @driver.stripe_uid.present?
  end
  
  def requests
    @requests = Request.where(driver: current_driver.number)
  end

  # GET /drivers/1/edit
  def edit
  end

  # POST /drivers
  # POST /drivers.json
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

  # PATCH/PUT /drivers/1
  # PATCH/PUT /drivers/1.json
  def update
    respond_to do |format|
      if @driver.update(driver_params)
        @driver.update!(registration_completed: true)
        if @driver.driver_approved
          format.html { redirect_to root_path, notice: 'Registration successful' }
        else
          format.html { redirect_to home_path, notice: 'Registration successful' }
        end
        format.json { render :show, status: :ok, location: @driver }
      else
        format.html { render :edit }
        format.json { render json: @driver.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /drivers/1
  # DELETE /drivers/1.json
  def destroy
    @driver.destroy
    respond_to do |format|
      format.html { redirect_to drivers_url, notice: 'Driver was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_driver
      @driver = Driver.find(params[:id])
    end
    
    # make sure the correct driver is authed
    def check_driver
      @driver = current_driver
      redirect_to root_path, notice: "Not authorized to access this page" if @driver.nil?
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def driver_params
      params.require(:driver).permit(:first_name, :last_name, :number, :street, :town, :state, :zipcode, :license_plate, :car_make, 
                                      :car_model, :car_year, :car_color, :approved, :avatar)
    end
end
