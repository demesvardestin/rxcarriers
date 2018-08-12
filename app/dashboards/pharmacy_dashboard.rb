require "administrate/base_dashboard"

class PharmacyDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    patients: Field::HasMany,
    invoices: Field::HasMany,
    deliveries: Field::HasMany,
    reviews: Field::HasMany,
    items: Field::HasMany,
    item_categories: Field::HasMany,
    inventory: Field::HasOne,
    orders: Field::HasMany,
    refunds: Field::HasMany,
    id: Field::Number,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
    email: Field::String,
    encrypted_password: Field::String,
    reset_password_token: Field::String,
    reset_password_sent_at: Field::DateTime,
    remember_created_at: Field::DateTime,
    sign_in_count: Field::Number,
    current_sign_in_at: Field::DateTime,
    last_sign_in_at: Field::DateTime,
    current_sign_in_ip: Field::String,
    last_sign_in_ip: Field::String,
    state: Field::String,
    number: Field::String,
    uid: Field::String,
    token: Field::String,
    provider: Field::String,
    stripe_connected: Field::Boolean,
    stripe_cus: Field::String,
    supervisor: Field::String,
    website: Field::String,
    bank_account_number: Field::String,
    country: Field::String,
    account_holder_name: Field::String,
    account_holder_type: Field::String,
    routing_number: Field::String,
    avatar_file_name: Field::String,
    avatar_content_type: Field::String,
    avatar_file_size: Field::Number,
    avatar_updated_at: Field::DateTime,
    card_number: Field::String,
    exp_year: Field::Number,
    exp_month: Field::Number,
    bill_street: Field::String,
    bill_city: Field::String,
    bill_state: Field::String,
    bill_zip: Field::String,
    bill_country: Field::String,
    cvc: Field::String,
    card_token: Field::String,
    firebase_id: Field::String,
    deliveries_today: Field::Number,
    subscribed_to_push: Field::Boolean,
    push_endpoint: Field::String,
    sub_auth: Field::String,
    p256dh: Field::String,
    npi: Field::String,
    name: Field::String,
    town: Field::String,
    street: Field::String,
    zipcode: Field::String,
    latitude: Field::Number.with_options(decimals: 2),
    longitude: Field::Number.with_options(decimals: 2),
    sub_plan: Field::String,
    sub_end_date: Field::DateTime,
    is_subscribed: Field::Boolean,
    delinquent: Field::Boolean,
    strikes: Field::Number,
    on_trial: Field::Boolean,
    hours: Field::String,
    delivers: Field::String,
    saturday: Field::String,
    sunday: Field::String,
    item_category_id: Field::Number,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :patients,
    :invoices,
    :deliveries,
    :reviews,
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :patients,
    :invoices,
    :deliveries,
    :reviews,
    :items,
    :item_categories,
    :inventory,
    :orders,
    :refunds,
    :id,
    :created_at,
    :updated_at,
    :email,
    :encrypted_password,
    :reset_password_token,
    :reset_password_sent_at,
    :remember_created_at,
    :sign_in_count,
    :current_sign_in_at,
    :last_sign_in_at,
    :current_sign_in_ip,
    :last_sign_in_ip,
    :state,
    :number,
    :uid,
    :token,
    :provider,
    :stripe_connected,
    :stripe_cus,
    :supervisor,
    :website,
    :bank_account_number,
    :country,
    :account_holder_name,
    :account_holder_type,
    :routing_number,
    :avatar_file_name,
    :avatar_content_type,
    :avatar_file_size,
    :avatar_updated_at,
    :card_number,
    :exp_year,
    :exp_month,
    :bill_street,
    :bill_city,
    :bill_state,
    :bill_zip,
    :bill_country,
    :cvc,
    :card_token,
    :firebase_id,
    :deliveries_today,
    :subscribed_to_push,
    :push_endpoint,
    :sub_auth,
    :p256dh,
    :npi,
    :name,
    :town,
    :street,
    :zipcode,
    :latitude,
    :longitude,
    :sub_plan,
    :sub_end_date,
    :is_subscribed,
    :delinquent,
    :strikes,
    :on_trial,
    :hours,
    :delivers,
    :saturday,
    :sunday,
    :item_category_id,
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :patients,
    :invoices,
    :deliveries,
    :reviews,
    :items,
    :item_categories,
    :inventory,
    :orders,
    :refunds,
    :email,
    :encrypted_password,
    :reset_password_token,
    :reset_password_sent_at,
    :remember_created_at,
    :sign_in_count,
    :current_sign_in_at,
    :last_sign_in_at,
    :current_sign_in_ip,
    :last_sign_in_ip,
    :state,
    :number,
    :uid,
    :token,
    :provider,
    :stripe_connected,
    :stripe_cus,
    :supervisor,
    :website,
    :bank_account_number,
    :country,
    :account_holder_name,
    :account_holder_type,
    :routing_number,
    :avatar_file_name,
    :avatar_content_type,
    :avatar_file_size,
    :avatar_updated_at,
    :card_number,
    :exp_year,
    :exp_month,
    :bill_street,
    :bill_city,
    :bill_state,
    :bill_zip,
    :bill_country,
    :cvc,
    :card_token,
    :firebase_id,
    :deliveries_today,
    :subscribed_to_push,
    :push_endpoint,
    :sub_auth,
    :p256dh,
    :npi,
    :name,
    :town,
    :street,
    :zipcode,
    :latitude,
    :longitude,
    :sub_plan,
    :sub_end_date,
    :is_subscribed,
    :delinquent,
    :strikes,
    :on_trial,
    :hours,
    :delivers,
    :saturday,
    :sunday,
    :item_category_id,
  ].freeze

  # Overwrite this method to customize how pharmacies are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(pharmacy)
  #   "Pharmacy ##{pharmacy.id}"
  # end
end
