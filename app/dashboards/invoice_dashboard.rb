require "administrate/base_dashboard"

class InvoiceDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    pharmacy: Field::BelongsTo,
    id: Field::Number,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
    description: Field::String,
    stripe_invoice_id: Field::String,
    amount: Field::Number,
    currency: Field::String,
    paid: Field::Boolean,
    request_id: Field::Number,
    batch_id: Field::Number,
    billing_date: Field::DateTime,
    stripe_status: Field::String,
    value: Field::String,
    active: Field::Boolean,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :pharmacy,
    :id,
    :created_at,
    :updated_at,
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :pharmacy,
    :id,
    :created_at,
    :updated_at,
    :description,
    :stripe_invoice_id,
    :amount,
    :currency,
    :paid,
    :request_id,
    :batch_id,
    :billing_date,
    :stripe_status,
    :value,
    :active,
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :pharmacy,
    :description,
    :stripe_invoice_id,
    :amount,
    :currency,
    :paid,
    :request_id,
    :batch_id,
    :billing_date,
    :stripe_status,
    :value,
    :active,
  ].freeze

  # Overwrite this method to customize how invoices are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(invoice)
  #   "Invoice ##{invoice.id}"
  # end
end
