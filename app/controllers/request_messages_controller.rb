class RequestMessagesController < ApplicationController
  before_action :unauthorized_access

  def create
    @request_message = RequestMessage.new(request_message_params)
    respond_to do |format|
      if @request_message.save
        format.json { render :show, status: :created, location: @invoice }
      end
    end
  end
  
  private
  
    def request_message_params
      params.fetch(:request_message, {}).require(:pharmacy_id, :driver_number, :from_number,
                    :message_sid, :date_created, :message_body, :batch_id, :type)
    end
    
end
