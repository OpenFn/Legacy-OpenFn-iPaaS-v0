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

ActiveRecord::Schema.define(version: 20141028141228) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "imports", force: true do |t|
    t.string   "odk_formid"
    t.string   "last_uuid"
    t.text     "cursor"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "num_imported", default: 0
  end

  create_table "mappings", force: true do |t|
    t.string   "name"
    t.string   "odk_formid"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "active",     default: false
    t.integer  "user_id"
  end

  add_index "mappings", ["user_id"], name: "index_mappings_on_user_id", using: :btree

  create_table "odk_field_salesforce_fields", force: true do |t|
    t.integer  "odk_field_id"
    t.integer  "salesforce_field_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "lookup_field_name"
  end

  add_index "odk_field_salesforce_fields", ["odk_field_id"], name: "index_odk_field_salesforce_fields_on_odk_field_id", using: :btree
  add_index "odk_field_salesforce_fields", ["salesforce_field_id"], name: "index_odk_field_salesforce_fields_on_salesforce_field_id", using: :btree

  create_table "odk_fields", force: true do |t|
    t.string   "field_name"
    t.string   "field_type"
    t.integer  "salesforce_field_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "odk_form_id"
  end

  add_index "odk_fields", ["odk_form_id"], name: "index_odk_fields_on_odk_form_id", using: :btree

  create_table "odk_forms", force: true do |t|
    t.string   "name"
    t.integer  "mapping_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "odk_forms", ["mapping_id"], name: "index_odk_forms_on_mapping_id", using: :btree

  create_table "products", force: true do |t|
    t.string  "name"
    t.string  "logo_path"
    t.string  "inactive_logo_path"
    t.boolean "active_source"
    t.boolean "active_destination"
  end

  create_table "salesforce_fields", force: true do |t|
    t.integer  "mapping_id"
    t.string   "object_name"
    t.string   "field_name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "data_type"
    t.string   "label_name"
    t.string   "color"
    t.boolean  "is_lookup",            default: false
    t.string   "lookup_object"
    t.string   "lookup_field"
    t.integer  "salesforce_object_id"
  end

  add_index "salesforce_fields", ["salesforce_object_id"], name: "index_salesforce_fields_on_salesforce_object_id", using: :btree

  create_table "salesforce_objects", force: true do |t|
    t.string   "name"
    t.string   "data_type"
    t.string   "label"
    t.string   "color"
    t.integer  "mapping_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "order"
    t.boolean  "is_repeat",  default: false
  end

  add_index "salesforce_objects", ["mapping_id"], name: "index_salesforce_objects_on_mapping_id", using: :btree

  create_table "salesforce_relationships", force: true do |t|
    t.integer  "salesforce_object_id"
    t.integer  "salesforce_field_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "salesforce_relationships", ["salesforce_field_id"], name: "index_salesforce_relationships_on_salesforce_field_id", using: :btree
  add_index "salesforce_relationships", ["salesforce_object_id"], name: "index_salesforce_relationships_on_salesforce_object_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "email",                             null: false
    t.string   "crypted_password",                  null: false
    t.string   "salt",                              null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "sf_username"
    t.string   "sf_password"
    t.string   "odk_url"
    t.string   "sf_security_token"
    t.boolean  "valid_credentials", default: false
    t.string   "sf_app_secret"
    t.string   "sf_app_key"
    t.string   "odk_username"
    t.string   "odk_password"
    t.string   "sf_host"
    t.string   "role"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree

end
