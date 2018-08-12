require "administrate/base_dashboard"

class OrderDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    pharmacy: Field::BelongsTo,
    cart: Field::HasOne,
    refund: Field::HasOne,
    id: Field::Number,
    cart_id: Field::Number,
    shopper_email: Field::String,
    item_list: Field::String,
    item_list_count: Field::String,
    total: Field::String,
    stripe_charge_id: Field::String,
    confirmation: Field::String,
    guest: Field::Boolean,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
    street_address: Field::String,
    town_state_zipcode: Field::String,
    phone_number: Field::String,
    apartment_number: Field::String,
    processed: Field::Boolean,
    requested_at: Field::Time,
    delivered: Field::Boolean,
    status: Field::String,
    online: Field::Boolean,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :pharmacy,
    :cart,
    :refund,
    :id,
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :pharmacy,
    :cart,
    :refund,
    :id,
    :cart_id,
    :shopper_email,
    :item_list,
    :item_list_count,
    :total,
    :stripe_charge_id,
    :confirmation,
    :guest,
    :created_at,
    :updated_at,
    :street_address,
    :town_state_zipcode,
    :phone_number,
    :apartment_number,
    :processed,
    :requested_at,
    :delivered,
    :status,
    :online,
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :pharmacy,
    :cart,
    :refund,
    :cart_id,
    :shopper_email,
    :item_list,
    :item_list_count,
    :total,
    :stripe_charge_id,
    :confirmation,
    :guest,
    :street_address,
    :town_state_zipcode,
    :phone_number,
    :apartment_number,
    :processed,
    :requested_at,
    :delivered,
    :status,
    :online,
  ].freeze

  # Overwrite this method to customize how orders are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(order)
  #   "Order ##{order.id}"
  # end
end
