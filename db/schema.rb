# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20180812133524) do

  create_table "batches", force: :cascade do |t|
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.string   "name"
    t.integer  "pharmacy_id"
    t.boolean  "deleted"
    t.string   "auto_id"
    t.boolean  "delivered"
    t.time     "requested_at"
    t.string   "address"
    t.string   "phone_number"
    t.string   "quote_id"
    t.integer  "quote_price"
    t.string   "courier_name"
    t.string   "courier_rating"
    t.string   "courier_vehicle_type"
    t.string   "courier_phone_number"
    t.string   "courier_avatar"
    t.string   "delivery_id"
    t.boolean  "courier_requested"
    t.string   "tracking_url"
    t.string   "status"
  end

  create_table "carts", force: :cascade do |t|
    t.integer  "item_count"
    t.string   "shopper_email"
    t.string   "total_cost"
    t.boolean  "pending"
    t.boolean  "completed"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.string   "item_list"
    t.string   "item_list_count"
    t.string   "instructions_list"
    t.integer  "order_id"
    t.string   "final_amount"
    t.string   "tip"
    t.string   "tip_amount"
    t.boolean  "paid"
    t.boolean  "online"
    t.integer  "pharmacy_id"
  end

  create_table "deliveries", force: :cascade do |t|
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.string   "deliverable_type"
    t.integer  "deliverable_id"
    t.string   "recipient_name"
    t.string   "recipient_phone_number"
    t.string   "recipient_address"
    t.string   "medications"
    t.integer  "pharmacy_id"
    t.string   "copay"
    t.string   "signature"
    t.datetime "signed_on"
    t.integer  "patient_id"
    t.string   "time"
    t.string   "matrix"
    t.string   "duration"
    t.boolean  "request_sent"
    t.text     "signature_image"
    t.datetime "request_sent_on"
    t.boolean  "completed"
    t.boolean  "deleted"
    t.string   "rx"
  end

  add_index "deliveries", ["deliverable_type", "deliverable_id"], name: "index_deliveries_on_deliverable_type_and_deliverable_id"

  create_table "delivery_hours", force: :cascade do |t|
    t.string   "monday"
    t.string   "tuesday"
    t.string   "wednesday"
    t.string   "thursday"
    t.string   "friday"
    t.string   "saturday"
    t.string   "sunday"
    t.integer  "pharmacy_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "delivery_requests", force: :cascade do |t|
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.string   "rx"
    t.boolean  "active"
    t.integer  "rx_id"
    t.integer  "pharmacy_id"
    t.string   "delivery_time"
    t.boolean  "is_valid"
    t.string   "request_ip"
  end

  create_table "help_tickets", force: :cascade do |t|
    t.integer  "pharmacy_id"
    t.string   "details"
    t.string   "title"
    t.string   "phone"
    t.string   "preferred_time"
    t.boolean  "processed"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "inventories", force: :cascade do |t|
    t.integer  "pharmacy_id"
    t.integer  "item_id"
    t.integer  "category_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.integer  "item_category_id"
  end

  create_table "invoices", force: :cascade do |t|
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.integer  "pharmacy_id"
    t.string   "description"
    t.string   "stripe_invoice_id"
    t.integer  "amount"
    t.string   "currency"
    t.boolean  "paid"
    t.integer  "request_id"
    t.integer  "batch_id"
    t.datetime "billing_date"
    t.string   "stripe_status"
    t.string   "value"
    t.boolean  "active"
  end

  create_table "item_categories", force: :cascade do |t|
    t.integer  "inventory_id"
    t.string   "name"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.integer  "pharmacy_id"
  end

  create_table "items", force: :cascade do |t|
    t.integer  "pharmacy_id"
    t.integer  "category_id"
    t.integer  "inventory_id"
    t.string   "name"
    t.string   "price"
    t.string   "quantity"
    t.string   "details"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.integer  "item_category_id"
    t.integer  "cart_id"
    t.boolean  "taxable"
    t.integer  "size"
    t.string   "size_type"
    t.integer  "invoice_id"
    t.string   "expiration"
    t.string   "ndc"
  end

  create_table "notifications", force: :cascade do |t|
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.integer  "pharmacy_id"
    t.integer  "batch_id"
    t.string   "content"
    t.boolean  "read"
    t.string   "notification_type"
    t.string   "rx"
    t.boolean  "active"
    t.string   "title"
  end

  create_table "orders", force: :cascade do |t|
    t.integer  "cart_id"
    t.integer  "pharmacy_id"
    t.string   "shopper_email"
    t.string   "item_list"
    t.string   "item_list_count"
    t.string   "total"
    t.string   "stripe_charge_id"
    t.string   "confirmation"
    t.boolean  "guest"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.string   "street_address"
    t.string   "town_state_zipcode"
    t.string   "phone_number"
    t.string   "apartment_number"
    t.boolean  "processed"
    t.time     "requested_at"
    t.boolean  "delivered"
    t.string   "status"
    t.boolean  "online"
  end

  create_table "pharmacies", force: :cascade do |t|
    t.datetime "created_at",                                  null: false
    t.datetime "updated_at",                                  null: false
    t.string   "email",                  default: "",         null: false
    t.string   "encrypted_password",     default: "",         null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,          null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "state"
    t.string   "number"
    t.string   "uid"
    t.string   "token"
    t.string   "provider"
    t.boolean  "stripe_connected"
    t.string   "stripe_cus"
    t.string   "supervisor"
    t.string   "website"
    t.string   "bank_account_number"
    t.string   "country"
    t.string   "account_holder_name"
    t.string   "account_holder_type"
    t.string   "routing_number"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.string   "card_number"
    t.integer  "exp_year"
    t.integer  "exp_month"
    t.string   "bill_street"
    t.string   "bill_city"
    t.string   "bill_state"
    t.string   "bill_zip"
    t.string   "bill_country"
    t.string   "cvc"
    t.string   "card_token"
    t.string   "firebase_id"
    t.integer  "deliveries_today"
    t.boolean  "subscribed_to_push"
    t.string   "push_endpoint"
    t.string   "sub_auth"
    t.string   "p256dh"
    t.string   "npi"
    t.string   "name"
    t.string   "town"
    t.string   "street"
    t.string   "zipcode"
    t.float    "latitude"
    t.float    "longitude"
    t.string   "sub_plan"
    t.date     "sub_end_date"
    t.boolean  "is_subscribed"
    t.boolean  "delinquent"
    t.integer  "strikes"
    t.boolean  "on_trial"
    t.string   "hours"
    t.string   "delivers"
    t.string   "saturday"
    t.string   "sunday"
    t.integer  "item_category_id"
    t.string   "delivery_option",        default: "delivers"
  end

  add_index "pharmacies", ["email"], name: "index_pharmacies_on_email"
  add_index "pharmacies", ["reset_password_token"], name: "index_pharmacies_on_reset_password_token", unique: true

  create_table "refill_deliveries", force: :cascade do |t|
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.string   "rx"
    t.boolean  "active"
    t.integer  "pharmacy_id"
    t.string   "delivery_time"
  end

  create_table "refunds", force: :cascade do |t|
    t.string   "amount"
    t.integer  "order_id"
    t.integer  "pharmacy_id"
    t.boolean  "completed"
    t.string   "details"
    t.string   "stripe_cus"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "registration_requests", force: :cascade do |t|
    t.string   "pharmacy_name"
    t.string   "pharmacy_email"
    t.string   "pharmacy_phone"
    t.string   "pharmacy_address"
    t.string   "pharmacy_manager"
    t.string   "pharmacy_website"
    t.string   "secure_token"
    t.boolean  "approved",          default: false
    t.datetime "approved_on"
    t.datetime "denied_on"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.string   "registration_link"
  end

  create_table "request_alerts", force: :cascade do |t|
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.string   "pharm_location"
    t.integer  "batch_id"
    t.integer  "deliveries"
    t.string   "pharm_name"
    t.string   "pharm_phone"
    t.string   "fare"
    t.string   "mileage"
    t.string   "duration"
    t.integer  "driver_id"
    t.integer  "pharm_id"
    t.string   "rx"
    t.string   "ip"
    t.string   "time"
    t.boolean  "active"
    t.boolean  "is_valid"
    t.string   "request_ip"
    t.integer  "pharmacy_id"
  end

  create_table "reviews", force: :cascade do |t|
    t.string   "content"
    t.integer  "pharmacy_id"
    t.boolean  "flagged"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "rxes", force: :cascade do |t|
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.string   "rx"
    t.datetime "last_filled_on"
    t.string   "current_status"
    t.integer  "pharmacy_id"
    t.integer  "batch_id"
    t.integer  "patient_id"
    t.string   "phone_number"
    t.string   "address"
    t.string   "delivery_instructions"
    t.string   "npi"
    t.boolean  "delivery_requested"
    t.string   "dob"
    t.boolean  "refill_requested"
    t.time     "requested_at"
    t.boolean  "processed"
    t.boolean  "deleted"
    t.string   "birth_year"
    t.string   "confirmation"
  end

  create_table "sendgrid_emails", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "shoppers", force: :cascade do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.boolean  "guest",                  default: false
  end

  add_index "shoppers", ["email"], name: "index_shoppers_on_email", unique: true
  add_index "shoppers", ["reset_password_token"], name: "index_shoppers_on_reset_password_token", unique: true

  create_table "stripe_plans", force: :cascade do |t|
    t.string   "name"
    t.integer  "pharmacy_id"
    t.datetime "next_billing_date"
    t.boolean  "active"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.string   "price"
  end

  create_table "terms_and_agreements", force: :cascade do |t|
    t.integer  "pharmacy_id"
    t.boolean  "signed"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.time     "signed_on"
  end

  create_table "twilio_patients", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.boolean  "guest",                  default: false
    t.string   "name"
    t.string   "phone"
    t.string   "street"
    t.string   "town"
    t.string   "state"
    t.string   "zipcode"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end
