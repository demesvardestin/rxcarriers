class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :redirect_from_cross_model
  
  def redirect_from_cross_model
    if current_pharmacy
      if request.original_url.include?("drivers/sign_up") || request.original_url.include?("drivers/sign_in")
        redirect_to authenticated_pharmacy_root_path
      end
    elsif current_driver
      if request.original_url.include?("pharmacies/sign_up") || request.original_url.include?("pharmacies/sign_in")
        redirect_to authenticated_driver_root_path
      end
    end
  end
end
