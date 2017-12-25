class CancellationMessagesController < ApplicationController
  before_action :unauthorized_access

  def create
    @cancellation_message = CancellationMessage.new(cancellation_message_params)
    respond_to do |format|
      if @cancellation_message.save
        format.js {render layout: false}
      end
    end
  end
  
  private
  
    def cancellation_message_params
      params.fetch(:cancellation_message, {}).require(:pharmacy_id, :driver_number, :from_number,
                    :message_sid, :date_created, :message_body, :batch_id, :type)
    end
end
