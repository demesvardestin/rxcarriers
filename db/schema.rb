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

ActiveRecord::Schema.define(version: 20171107034710) do

  create_table "batches", force: :cascade do |t|
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "notes"
    t.integer  "pharmacy_id"
  end

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
  end

  create_table "drivers", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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
  end

  create_table "patients", force: :cascade do |t|
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
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
  end

  add_index "patients", ["patable_type", "patable_id"], name: "index_patients_on_patable_type_and_patable_id"

  create_table "pharmacies", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "name"
    t.string   "street"
    t.string   "town"
    t.string   "zipcode"
    t.integer  "identifier"
    t.float    "latitude"
    t.float    "longitude"
  end

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

# Could not dump table "requests" because of following NoMethodError
#   undefined method `[]' for nil:NilClass

end
