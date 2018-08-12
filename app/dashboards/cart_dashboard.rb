require "administrate/base_dashboard"

class CartDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    items: Field::HasMany,
    order: Field::BelongsTo,
    id: Field::Number,
    item_count: Field::Number,
    shopper_email: Field::String,
    total_cost: Field::String,
    pending: Field::Boolean,
    completed: Field::Boolean,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
    item_list: Field::String,
    item_list_count: Field::String,
    instructions_list: Field::String,
    final_amount: Field::String,
    tip: Field::String,
    tip_amount: Field::String,
    paid: Field::Boolean,
    online: Field::Boolean,
    pharmacy_id: Field::Number,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :items,
    :order,
    :id,
    :item_count,
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :items,
    :order,
    :id,
    :item_count,
    :shopper_email,
    :total_cost,
    :pending,
    :completed,
    :created_at,
    :updated_at,
    :item_list,
    :item_list_count,
    :instructions_list,
    :final_amount,
    :tip,
    :tip_amount,
    :paid,
    :online,
    :pharmacy_id,
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :items,
    :order,
    :item_count,
    :shopper_email,
    :total_cost,
    :pending,
    :completed,
    :item_list,
    :item_list_count,
    :instructions_list,
    :final_amount,
    :tip,
    :tip_amount,
    :paid,
    :online,
    :pharmacy_id,
  ].freeze

  # Overwrite this method to customize how carts are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(cart)
  #   "Cart ##{cart.id}"
  # end
end
