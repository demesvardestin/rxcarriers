require "administrate/base_dashboard"

class ItemDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    pharmacy: Field::BelongsTo,
    inventory: Field::BelongsTo,
    item_category: Field::BelongsTo,
    cart: Field::BelongsTo,
    id: Field::Number,
    category_id: Field::Number,
    name: Field::String,
    price: Field::String,
    quantity: Field::String,
    details: Field::String,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
    taxable: Field::Boolean,
    size: Field::Number,
    size_type: Field::String,
    invoice_id: Field::Number,
    expiration: Field::String,
    ndc: Field::String,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :pharmacy,
    :inventory,
    :item_category,
    :cart,
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :pharmacy,
    :inventory,
    :item_category,
    :cart,
    :id,
    :category_id,
    :name,
    :price,
    :quantity,
    :details,
    :created_at,
    :updated_at,
    :taxable,
    :size,
    :size_type,
    :invoice_id,
    :expiration,
    :ndc,
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :pharmacy,
    :inventory,
    :item_category,
    :cart,
    :category_id,
    :name,
    :price,
    :quantity,
    :details,
    :taxable,
    :size,
    :size_type,
    :invoice_id,
    :expiration,
    :ndc,
  ].freeze

  # Overwrite this method to customize how items are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(item)
  #   "Item ##{item.id}"
  # end
end
