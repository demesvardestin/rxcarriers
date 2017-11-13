class InvoicesController < ApplicationController
  
  def index
    @invoices = Invoice.where(pharmacy_id: current_pharmacy.id).all
    @charge = Charge.new
  end
  
  def create
  end
  
end
