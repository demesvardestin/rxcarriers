class Cart < ActiveRecord::Base
    has_many :items
    belongs_to :order
    
    def add_item(id, count, instructions='none')
        instructions == 'none' ? instructions = instructions : instructions = instructions.split(',').join(' ')
        item_list = self.item_list
        item_list_count = self.item_list_count
        instructions_list = self.instructions_list
        if self.item_list == ''
            self.update(
                item_list: item_list << id,
                item_list_count: item_list_count << count,
                instructions_list: instructions_list << instructions,
                total_cost: total_cost
            )
        else
            self.update(
                item_list: item_list << ', ' + id,
                item_list_count: item_list_count << ', ' + count,
                instructions_list: instructions_list << ', ' + instructions,
                total_cost: total_cost
            )
        end
        total_cost = 0.0
        self.item_list.split(', ').each_with_index do |i, idx|
            total_cost += (Item.find_by(id: i.to_i).get_price * self.item_list_count.split(', ')[idx].to_i)
        end
        self.update(total_cost: total_cost)
    end
    
    def remove_item(item_id)
        index = self.item_list.split(', ').index("#{item_id}")
        new_item_list = self.item_list.split(', ')
        new_item_list.delete("#{item_id}")
        new_item_list = new_item_list.join(', ')
        new_item_list_count = self.item_list_count.split(', ')
        new_item_list_count.delete_at(index)
        new_item_list_count = new_item_list_count.join(', ')
        new_instructions_list = self.instructions_list.split(', ')
        new_instructions_list.delete_at(index)
        new_instructions_list = new_instructions_list.join(', ')
        total_cost = 0.0
        new_item_list.split(', ').each_with_index do |i, idx|
            total_cost += (Item.find_by(id: i.to_i).get_price * new_item_list_count.split(', ')[idx].to_i)
        end
        self.update(
            item_list: new_item_list,
            item_list_count: new_item_list_count,
            instructions_list: new_instructions_list,
            total_cost: total_cost
        )
    end
    
    def clear_cart
        self.update(item_list: '', item_list_count: '', instructions_list: '', total_cost: '0.0', tip: '10%', tip_amount: '0.0') 
    end
    
    def is_empty?
       return self.item_list == '' && self.item_list_count == '' && self.instructions_list == '' && self.pending == true
    end
    
    def process_payment(token, full_address, phone, apt_num, email, delivery_option)
        shopper_email = self.shopper_email
        shopper_email.starts_with?('guest')? guest = true : guest = false
        pharmacy_id = self.get_pharmacy.id
        confirmation = self.generate_confirmation
        total_amount = (self.sale_total * 100).to_i
        fee = (total_amount * 0.10).to_i
        charge = Stripe::Charge.create(
            {
                :amount => total_amount,
                :currency => "usd",
                :source => token[:id],
                :description => "Order from cart ##{self.id}. Email: #{email}",
                # :application_fee => fee,
                :destination => {
                    :account => self.get_pharmacy.stripe_cus,
                }
            }
        )
        order = Order.create(
            cart_id: self.id,
            pharmacy_id: pharmacy_id,
            shopper_email: shopper_email,
            guest: guest,
            item_list: self.item_list,
            item_list_count: self.item_list_count,
            total: self.total_cost,
            stripe_charge_id: charge.id,
            confirmation: confirmation,
            street_address: full_address,
            phone_number: phone,
            apartment_number: apt_num,
            ordered_at: Time.zone.now,
            online: true,
            delivered: false,
            processed: false,
            status: 'pending',
            delivery_email: email,
            delivery_option: delivery_option
        )
        invoice = Invoice.set_invoice(fee=0.0, net=total_amount, order, self)
        self.update(order_id: order.id, completed: true, shopper_email: '')
    end
    
    def calculate_tip(tip=nil)
       tip.nil? ? tip = self.tip.split('%').join('') : tip.split('%').join('')
       tip_amount = (((self.get_total_cost + self.calculate_tax) * tip.to_i)/100).round(2)
       total = (self.get_total_cost + self.calculate_tax) + tip_amount
       self.update(final_amount: total, tip_amount: tip_amount, tip: tip)
    end
    
    def generate_confirmation
        rand(1000000..9999999)
    end
    
    def item_count
        count = 0
        self.item_list_count.split(', ').each do |i|
            count += i.to_i 
        end
        count
    end
    
    def total(item)
        id = item.id
        index = self.item_list.split(', ').index("#{id}")
        return self.item_list_count.split(', ')[index]
    end
    
    def get_total_cost
        self.total_cost.to_f.round(2)
    end
    
    def calculate_tax
        tax_total = 0.0
        self.item_list.split(', ').each_with_index do |i, idx|
            @item = Item.find_by(id: i.to_i)
            if @item.is_taxable? && @item.pharmacy.state.downcase.include?('ny')
                tax_total += (@item.get_price.to_f * 0.08875 * self.item_list_count.split(', ')[idx].to_i).round(2)
            elsif @item.pharmacy.state.downcase.include?('ma')
                tax_total += (@item.get_price.to_f * 0.05 * self.item_list_count.split(', ')[idx].to_i).round(2)
            end
        end
        return tax_total
    end
    
    def get_tip
        if self.tip_amount.to_f == 0
            tip = (((self.get_total_cost + self.calculate_tax) * self.tip.to_i)/100).round(2)
            self.update(tip_amount: tip)
        else
            tip = self.tip_amount.to_f
        end
        return tip
    end
    
    def get_pharmacy
        @item = Item.find_by(id: self.item_list.split(', ')[0].to_i)
        if @item.nil?
            return
        end
        @pharmacy = Pharmacy.find_by(id: @item.pharmacy_id) 
    end
    
    def sale_total
        self.final_amount.nil? ? final = 0.0 : final = self.final_amount
        (self.get_total_cost + self.calculate_tax + self.get_tip).round(2)
    end
    
    def item_list_array
        self.item_list.split(', ') 
    end
    
    def item_list_count_array
        self.item_list_count.split(', ') 
    end
    
    def instruction_list_array
        self.instructions_list.split(', ') 
    end
end
