require "administrate/base_dashboard"

class StripePlanDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    id: Field::Number,
    name: Field::String,
    pharmacy_id: Field::Number,
    next_billing_date: Field::DateTime,
    active: Field::Boolean,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
    price: Field::String,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :id,
    :name,
    :pharmacy_id,
    :next_billing_date,
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :id,
    :name,
    :pharmacy_id,
    :next_billing_date,
    :active,
    :created_at,
    :updated_at,
    :price,
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :name,
    :pharmacy_id,
    :next_billing_date,
    :active,
    :price,
  ].freeze

  # Overwrite this method to customize how stripe plans are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(stripe_plan)
  #   "StripePlan ##{stripe_plan.id}"
  # end
end
