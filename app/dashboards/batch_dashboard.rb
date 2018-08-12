require "administrate/base_dashboard"

class BatchDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    pharmacy: Field::BelongsTo,
    rxes: Field::HasMany,
    id: Field::Number,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
    name: Field::String,
    deleted: Field::Boolean,
    auto_id: Field::String,
    delivered: Field::Boolean,
    requested_at: Field::Time,
    address: Field::String,
    phone_number: Field::String,
    quote_id: Field::String,
    quote_price: Field::Number,
    courier_name: Field::String,
    courier_rating: Field::String,
    courier_vehicle_type: Field::String,
    courier_phone_number: Field::String,
    courier_avatar: Field::String,
    delivery_id: Field::String,
    courier_requested: Field::Boolean,
    tracking_url: Field::String,
    status: Field::String,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :pharmacy,
    :rxes,
    :id,
    :created_at,
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :pharmacy,
    :rxes,
    :id,
    :created_at,
    :updated_at,
    :name,
    :deleted,
    :auto_id,
    :delivered,
    :requested_at,
    :address,
    :phone_number,
    :quote_id,
    :quote_price,
    :courier_name,
    :courier_rating,
    :courier_vehicle_type,
    :courier_phone_number,
    :courier_avatar,
    :delivery_id,
    :courier_requested,
    :tracking_url,
    :status,
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :pharmacy,
    :rxes,
    :name,
    :deleted,
    :auto_id,
    :delivered,
    :requested_at,
    :address,
    :phone_number,
    :quote_id,
    :quote_price,
    :courier_name,
    :courier_rating,
    :courier_vehicle_type,
    :courier_phone_number,
    :courier_avatar,
    :delivery_id,
    :courier_requested,
    :tracking_url,
    :status,
  ].freeze

  # Overwrite this method to customize how batches are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(batch)
  #   "Batch ##{batch.id}"
  # end
end
