class HelpTicketsController < ApplicationController
  def index
  end

  def create
    @ticket = HelpTicket.new(ticket_params)
    @ticket.pharmacy = current_pharmacy
    respond_to do |format|
      if @ticket.save
        format.js { render :layout => false }
      else
        format.js { render 'ticket_error', :layout => false }
      end
    end
  end
  
  private
  
  def ticket_params
    params.require(:help_ticket).permit(:title, :preferred_time, :details)
  end
end
