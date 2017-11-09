module Accessible
  extend ActiveSupport::Concern
  included do
    before_action :check_user
  end

  protected
  def check_user
    flash.clear
    if current_driver
      redirect_to(authenticated_driver_root_path) && return
    else current_pharmacy
     redirect_to(authenticated_pharmacy_root_path) && return
    end
  end
end