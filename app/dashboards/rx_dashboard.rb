require "administrate/base_dashboard"

class RxDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    delivery_requests: Field::HasMany,
    batch: Field::BelongsTo,
    pharmacy: Field::BelongsTo,
    id: Field::Number,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
    rx: Field::String,
    last_filled_on: Field::DateTime,
    current_status: Field::String,
    patient_id: Field::Number,
    phone_number: Field::String,
    address: Field::String,
    delivery_instructions: Field::String,
    npi: Field::String,
    delivery_requested: Field::Boolean,
    dob: Field::String,
    refill_requested: Field::Boolean,
    requested_at: Field::Time,
    processed: Field::Boolean,
    deleted: Field::Boolean,
    birth_year: Field::String,
    confirmation: Field::String,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :delivery_requests,
    :batch,
    :pharmacy,
    :id,
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :delivery_requests,
    :batch,
    :pharmacy,
    :id,
    :created_at,
    :updated_at,
    :rx,
    :last_filled_on,
    :current_status,
    :patient_id,
    :phone_number,
    :address,
    :delivery_instructions,
    :npi,
    :delivery_requested,
    :dob,
    :refill_requested,
    :requested_at,
    :processed,
    :deleted,
    :birth_year,
    :confirmation,
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :delivery_requests,
    :batch,
    :pharmacy,
    :rx,
    :last_filled_on,
    :current_status,
    :patient_id,
    :phone_number,
    :address,
    :delivery_instructions,
    :npi,
    :delivery_requested,
    :dob,
    :refill_requested,
    :requested_at,
    :processed,
    :deleted,
    :birth_year,
    :confirmation,
  ].freeze

  # Overwrite this method to customize how rxes are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(rx)
  #   "Rx ##{rx.id}"
  # end
end
