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

ActiveRecord::Schema.define(version: 20141203143306) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "hstore"

  create_table "api_keys", force: true do |t|
    t.string "role"
    t.string "access_token"
  end

  create_table "blog_posts", force: true do |t|
    t.string   "salesforce_name"
    t.text     "content"
    t.boolean  "published"
    t.datetime "publication_date"
    t.text     "title"
  end

  create_table "credentials", force: true do |t|
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.hstore   "details"
  end

  create_table "imports", force: true do |t|
    t.string   "odk_formid"
    t.string   "last_uuid"
    t.text     "cursor"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "num_imported", default: 0
    t.integer  "mapping_id"
  end

  add_index "imports", ["mapping_id"], name: "index_imports_on_mapping_id", using: :btree

  create_table "integration_destinations", force: true do |t|
    t.integer "product_id"
    t.integer "credential_id"
  end

  create_table "integration_sources", force: true do |t|
    t.integer "product_id"
    t.integer "credential_id"
    t.integer "api_key_id"
  end

  create_table "integrations", force: true do |t|
    t.integer "user_id"
    t.string  "name"
    t.integer "source_id"
    t.integer "destination_id"
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
    t.boolean  "is_uuid",             default: false
    t.boolean  "uuidable",            default: false
    t.boolean  "repeat_field",        default: false
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
    t.text    "description"
    t.string  "salesforce_id"
    t.string  "website"
    t.boolean "enabled"
    t.boolean "integrated",           default: false
    t.text    "costs"
    t.text    "reviews"
    t.text    "resources"
    t.text    "provider"
    t.text    "detailed_description"
    t.string  "update_link"
    t.string  "integration_type"
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

  create_table "submission_records", force: true do |t|
    t.integer  "integration_id"
    t.text     "raw_source_payload"
    t.hstore   "source_payload"
    t.hstore   "destination_payload"
    t.text     "raw_destination_payload"
    t.datetime "processed_at"
  end

  create_table "submissions", force: true do |t|
    t.string   "uuid"
    t.string   "state"
    t.json     "data"
    t.integer  "import_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "message"
    t.text     "backtrace"
  end

  create_table "taggings", force: true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       limit: 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true, using: :btree
  add_index "taggings", ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context", using: :btree

  create_table "tags", force: true do |t|
    t.string  "name"
    t.integer "taggings_count", default: 0
  end

  add_index "tags", ["name"], name: "index_tags_on_name", unique: true, using: :btree

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
    t.integer  "credits"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "organisation"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree

end
