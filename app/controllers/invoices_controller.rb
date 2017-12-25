class InvoicesController < ApplicationController
  
  before_action :unauthorized_access, only: [:create]
  before_action :check_current_pharmacy
  
  def index
    @invoices = Invoice.where(pharmacy_id: current_pharmacy.id).paginate(:page => params[:page], :per_page => 10)
    @charge = Charge.new
  end
  
  def create
    @invoice = Invoice.new(invoice_params)
    @invoice.pharmacy = current_pharmacy
    if @invoice.save
      respond_to do |format|
        format.json { render :show, status: :created, location: @invoice }
      end
    end
  end
  
end
