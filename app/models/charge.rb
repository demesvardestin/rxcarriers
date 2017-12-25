class Charge < ActiveRecord::Base
    belongs_to :pharmacy
    
    def self.charge_pharmacy(pharmacy, batch, driver, req, amount)
        description = "Payment for the delivery of Batch ##{batch.id}"
        percentage = (15.0/100.0) * amount
        total = amount - percentage.to_i
        customer = Stripe::Customer.retrieve(pharmacy.stripe_cus)
        charge = Stripe::Charge.create(
            {
                :customer => customer,
                :amount => amount,
                :description => description,
                :currency => 'usd',
                :source => customer.sources.first,
                :destination => {
                    :amount => total,
                    :account => driver.stripe_uid,
                }
            }
        )
        Invoice.create!(description: "charge ##{charge.id}")
    end
    
    def self.create_charge(pharmacy, batch, driver, req, amount)
        @invoice = Invoice.where(pharmacy_id: pharmacy.id).last
        invoice_item = Stripe::InvoiceItem.create(
            :customer => pharmacy.stripe_cus,
            :amount => amount,
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
            amount: amount,
            currency: "usd"
        )
        @invoice.update(stripe_invoice_id: stripe_invoice.id, billing_date: nil)
        # stripe_invoice.next_payment_attempt.to_s.to_datetime
    end
    
    def self.update_bank_info(pharmacy)
        begin
            customer = Stripe::Customer.retrieve(pharmacy.stripe_cus)
        rescue
            customer = Stripe::Customer.create(
                :description => pharmacy.name,
                :email => pharmacy.email
            )
            pharmacy.update(stripe_cus: customer.id, stripe_connected: true)
        end
        customer.sources.create(
            source: {
                :object => "card",
                :number => pharmacy.card_number,
                :address_country => pharmacy.bill_country,
                :currency => 'usd',
                :address_city => pharmacy.bill_city,
                :address_line1 => pharmacy.bill_street,
                :address_state => pharmacy.bill_state,
                :address_zip => pharmacy.bill_zip,
                :exp_year => pharmacy.exp_year,
                :exp_month => pharmacy.exp_month
            }
        )
    end
    
end
