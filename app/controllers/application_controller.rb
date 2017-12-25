class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :redirect_from_cross_model
  
  
  def redirect_from_cross_model
    url = request.original_url
    if current_pharmacy
      if url.include?("drivers/sign_up") || url.include?("drivers/sign_in")
        redirect_to authenticated_pharmacy_root_path
      end
    elsif current_driver
      if url.include?("pharmacies/sign_up") || url.include?("pharmacies/sign_in")
        redirect_to authenticated_driver_root_path
      end
    end
  end
  
  def check_current_pharmacy
    redirect_to unauthorized_path unless current_pharmacy
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
