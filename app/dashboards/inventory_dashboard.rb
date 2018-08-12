require "administrate/base_dashboard"

class InventoryDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    items: Field::HasMany,
    item_categories: Field::HasMany,
    pharmacy: Field::BelongsTo,
    id: Field::Number,
    item_id: Field::Number,
    category_id: Field::Number,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
    item_category_id: Field::Number,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :items,
    :item_categories,
    :pharmacy,
    :id,
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :items,
    :item_categories,
    :pharmacy,
    :id,
    :item_id,
    :category_id,
    :created_at,
    :updated_at,
    :item_category_id,
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :items,
    :item_categories,
    :pharmacy,
    :item_id,
    :category_id,
    :item_category_id,
  ].freeze

  # Overwrite this method to customize how inventories are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(inventory)
  #   "Inventory ##{inventory.id}"
  # end
end
