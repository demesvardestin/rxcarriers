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

ActiveRecord::Schema.define(version: 20180315203029) do

# Could not dump table "batches" because of following NoMethodError
#   undefined method `[]' for nil:NilClass

  create_table "cancellation_messages", force: :cascade do |t|
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.integer  "pharmacy_id"
    t.integer  "batch_id"
    t.string   "driver_number"
    t.string   "from_number"
    t.string   "message_sid"
    t.string   "date_created"
    t.string   "message_body"
    t.string   "type"
    t.string   "request_type"
  end

  create_table "charges", force: :cascade do |t|
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "pharmacy_id"
    t.integer  "batch_id"
    t.string   "description"
    t.string   "email"
    t.string   "card_token"
    t.string   "amount"
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
  end

  add_index "deliveries", ["deliverable_type", "deliverable_id"], name: "index_deliveries_on_deliverable_type_and_deliverable_id"

  create_table "drivers", force: :cascade do |t|
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "number"
    t.string   "street"
    t.string   "town"
    t.string   "zipcode"
    t.float    "latitude"
    t.float    "longitude"
    t.boolean  "requested"
    t.boolean  "clocked_in"
    t.string   "state"
    t.string   "license_plate"
    t.string   "car_make"
    t.string   "car_model"
    t.string   "car_year"
    t.string   "car_color"
    t.boolean  "registration_completed"
    t.boolean  "driver_approved"
    t.string   "stripe_uid"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.string   "bank_account_number"
    t.string   "country"
    t.string   "account_holder_name"
    t.string   "account_holder_type"
    t.string   "routing_number"
    t.string   "soc"
    t.string   "dob"
    t.string   "middle_name"
    t.string   "gender"
    t.boolean  "onboarded"
    t.boolean  "onfido_created"
    t.string   "exp_month"
    t.string   "exp_year"
    t.string   "cvc"
    t.string   "stripe_token"
  end

  add_index "drivers", ["email"], name: "index_drivers_on_email", unique: true
  add_index "drivers", ["reset_password_token"], name: "index_drivers_on_reset_password_token", unique: true

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
  end

  create_table "packs", force: :cascade do |t|
    t.string   "controller"
    t.string   "package"
    t.string   "create"
    t.string   "update"
    t.string   "destroy"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.string   "packageable_type"
    t.integer  "packageable_id"
    t.string   "recipient_name"
    t.string   "recipient_phone_number"
    t.string   "recipient_address"
    t.string   "medications"
    t.integer  "pharmacy_id"
  end

  add_index "packs", ["packageable_type", "packageable_id"], name: "index_packs_on_packageable_type_and_packageable_id"

  create_table "patients", force: :cascade do |t|
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.string   "name"
    t.string   "address"
    t.string   "phone"
    t.string   "note"
    t.string   "copay"
    t.float    "latitude"
    t.float    "longitude"
    t.integer  "pharmacy_id"
    t.integer  "batch_id"
    t.string   "patable_type"
    t.integer  "patable_id"
    t.string   "medications"
    t.string   "bank_account_number"
    t.string   "country"
    t.string   "account_holder_name"
    t.string   "account_holder_type"
    t.string   "routing_number"
    t.string   "card_number"
    t.integer  "exp_month"
    t.integer  "exp_year"
    t.integer  "cvc"
    t.string   "dob"
    t.string   "insured"
    t.string   "delivery_instructions"
    t.string   "stripe_cus"
    t.string   "card_token"
  end

  add_index "patients", ["patable_type", "patable_id"], name: "index_patients_on_patable_type_and_patable_id"

  create_table "pharmacies", force: :cascade do |t|
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "name"
    t.string   "street"
    t.string   "town"
    t.string   "zipcode"
    t.integer  "identifier"
    t.float    "latitude"
    t.float    "longitude"
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
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
  end

  add_index "pharmacies", ["email"], name: "index_pharmacies_on_email", unique: true
  add_index "pharmacies", ["reset_password_token"], name: "index_pharmacies_on_reset_password_token", unique: true

  create_table "request_messages", force: :cascade do |t|
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.integer  "pharmacy_id"
    t.integer  "batch_id"
    t.string   "driver_number"
    t.string   "from_number"
    t.string   "message_sid"
    t.string   "date_created"
    t.string   "message_body"
    t.string   "type"
    t.string   "date_sent"
    t.string   "request_type"
    t.string   "driver"
    t.string   "status"
  end

  create_table "requests", force: :cascade do |t|
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.string   "patients"
    t.integer  "batch_id"
    t.integer  "count"
    t.string   "driver"
    t.string   "status"
    t.string   "body"
    t.integer  "pharmacy_id"
    t.string   "driver_number"
    t.string   "car_make"
    t.string   "car_model"
    t.string   "car_year"
    t.string   "car_color"
    t.string   "license_plate"
    t.string   "driver_name"
  end

  create_table "supports", force: :cascade do |t|
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.string   "question_details"
    t.string   "pharmacy_name"
    t.string   "pharmacy_email"
    t.string   "pharmacy_number"
    t.string   "issue_type"
    t.integer  "pharmacy_id"
    t.string   "title"
    t.text     "body"
    t.string   "tags"
  end

end
