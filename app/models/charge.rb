class Charge < ActiveRecord::Base
    belongs_to :pharmacy
    
    def self.create_charge(pharmacy, batch, driver, req)
        @invoice = Invoice.where(pharmacy_id: pharmacy.id).last
        invoice_item = Stripe::InvoiceItem.create(
            :customer => pharmacy.stripe_cus,
            :amount => 3500,
            :currency => 'usd',
            :description => "Request sent for Batch: #{batch.id}"
        )
        if @invoice.nil?
            stripe_invoice = Stripe::Invoice.create(
                {
                    :customer => pharmacy.stripe_cus,
                    :description => "Request sent for Batch: #{batch.id}"
                }
            )
        else
            if Stripe::Invoice.retrieve(@invoice.stripe_invoice_id).paid
                stripe_invoice = Stripe::Invoice.create(
                    {
                        :customer => pharmacy.stripe_cus,
                        :description => "Request sent for Batch: #{batch.id}"
                    }
                )
            else
                stripe_invoice = Stripe::Invoice.retrieve(@invoice.stripe_invoice_id)
            end
        end
        @invoice = Invoice.create!(
            pharmacy_id: pharmacy.id,
            request_id: req.id,
            batch_id: batch.id,
            description: "Request sent for Batch: #{batch.id}",
            amount: 35,
            currency: "usd"
        )
        @invoice.update!(stripe_invoice_id: stripe_invoice.id, billing_date: stripe_invoice.next_payment_attempt.to_s.to_datetime)
    end
    
    def self.update_bank_info(pharmacy)
        begin
            customer = Stripe::Customer.retrieve(pharmacy.stripe_cus)
        rescue
            customer = Stripe::Customer.create(
                :description => pharmacy.name,
                :email => pharmacy.email
            )
            pharmacy.update!(stripe_cus: customer.id, stripe_connected: true)
        end
        customer.sources.create(
            source: {
                :object => "bank_account",
                :account_number => pharmacy.bank_account_number,
                :country => pharmacy.country,
                :currency => 'usd',
                :account_holder_name => pharmacy.account_holder_name,
                :account_holder_type => pharmacy.account_holder_type,
                :routing_number => pharmacy.routing_number
            }
        )
    end
    
end
