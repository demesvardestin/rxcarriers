class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  
  protect_from_forgery with: :exception
  before_action :check_token
  
  def check_driver_path
    
  end
  
  def check_token
    url = request.original_url
    @token = params[:secure_token]
    if url.include?('pharmacy/signup')
      redirect_to root_path if @token.nil? || !RegistrationRequest.exists?(secure_token: @token)
    end
    @registration = RegistrationRequest.find_by(secure_token: @token)
  end
  
  def check_current_pharmacy
    redirect_to :back unless current_pharmacy
  end
  
  def check_current_driver
    redirect_to unauthorized_path unless current_driver
  end
  
  def check_authenticated
    redirect_to unauthorized_path unless authenticated_user
  end
  
  def authenticated_user
    current_driver || current_pharmacy
  end
  
  def unauthorized_access
    redirect_to unauthorized_path
  end
  
end
