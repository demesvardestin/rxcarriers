require "administrate/base_dashboard"

class TermsAndAgreementDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    id: Field::Number,
    pharmacy_id: Field::Number,
    signed: Field::Boolean,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
    signed_on: Field::Time,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :id,
    :pharmacy_id,
    :signed,
    :created_at,
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :id,
    :pharmacy_id,
    :signed,
    :created_at,
    :updated_at,
    :signed_on,
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :pharmacy_id,
    :signed,
    :signed_on,
  ].freeze

  # Overwrite this method to customize how terms and agreements are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(terms_and_agreement)
  #   "TermsAndAgreement ##{terms_and_agreement.id}"
  # end
end
