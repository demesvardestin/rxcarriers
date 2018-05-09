class Driver::RegistrationsController < Devise::RegistrationsController
    # include Accessible
    # skip_before_action :check_user, only: :destroy
    before_filter :configure_permitted_parameters
    
    protected
    
    def configure_permitted_parameters
        devise_parameter_sanitizer.permit(:sign_up, keys: [:email, :password])
        devise_parameter_sanitizer.permit(:sign_in, keys: [:email, :password])
        devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name, :number, :street, :town, :state, :zipcode, :license_plate, :car_make, :car_model, :car_year, :car_color, :avatar])
    end
    
    def after_sign_up_path_for(resource)
        root_path
    end

end