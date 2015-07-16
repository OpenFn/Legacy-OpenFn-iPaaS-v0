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

ActiveRecord::Schema.define(version: 20150716073901) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "hstore"

  create_table "api_keys", force: true do |t|
    t.string  "role"
    t.string  "access_token"
    t.integer "connected_app_id"
  end

  create_table "collaborations", force: true do |t|
    t.integer  "user_id"
    t.integer  "project_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "collaborations", ["project_id"], name: "index_collaborations_on_project_id", using: :btree
  add_index "collaborations", ["user_id"], name: "index_collaborations_on_user_id", using: :btree

  create_table "connected_apps", force: true do |t|
    t.string  "name"
    t.integer "product_id"
    t.integer "user_id"
  end

  create_table "connection_profiles", force: true do |t|
    t.string   "name"
    t.integer  "product_id"
    t.integer  "user_id"
    t.integer  "credential_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "type"
  end

  create_table "credentials", force: true do |t|
    t.integer  "connected_app_id"
    t.hstore   "details"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "type"
    t.datetime "verified"
  end

  add_index "credentials", ["type"], name: "index_credentials_on_type", using: :btree

  create_table "drafts", force: true do |t|
    t.string   "item_type",      null: false
    t.integer  "item_id",        null: false
    t.string   "event",          null: false
    t.string   "whodunnit"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.json     "object"
    t.json     "previous_draft"
  end

  add_index "drafts", ["created_at"], name: "index_drafts_on_created_at", using: :btree
  add_index "drafts", ["event"], name: "index_drafts_on_event", using: :btree
  add_index "drafts", ["item_id"], name: "index_drafts_on_item_id", using: :btree
  add_index "drafts", ["item_type"], name: "index_drafts_on_item_type", using: :btree
  add_index "drafts", ["updated_at"], name: "index_drafts_on_updated_at", using: :btree
  add_index "drafts", ["whodunnit"], name: "index_drafts_on_whodunnit", using: :btree

  create_table "field_mappings", force: true do |t|
    t.integer "mapping_id"
    t.string  "source_field"
    t.string  "destination_field"
  end

  create_table "legacy_odk_field_salesforce_fields", force: true do |t|
    t.integer  "odk_field_id"
    t.integer  "salesforce_field_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "lookup_field_name"
  end

  add_index "legacy_odk_field_salesforce_fields", ["odk_field_id"], name: "index_legacy_odk_field_salesforce_fields_on_odk_field_id", using: :btree
  add_index "legacy_odk_field_salesforce_fields", ["salesforce_field_id"], name: "index_legacy_odk_field_salesforce_fields_on_salesforce_field_id", using: :btree

  create_table "legacy_salesforce_relationships", force: true do |t|
    t.integer  "salesforce_object_id"
    t.integer  "salesforce_field_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "legacy_salesforce_relationships", ["salesforce_field_id"], name: "index_legacy_salesforce_relationships_on_salesforce_field_id", using: :btree
  add_index "legacy_salesforce_relationships", ["salesforce_object_id"], name: "index_legacy_salesforce_relationships_on_salesforce_object_id", using: :btree

  create_table "mappings", force: true do |t|
    t.string   "name"
    t.integer  "source_connected_app_id"
    t.integer  "destination_connected_app_id"
    t.boolean  "active"
    t.boolean  "enabled"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  add_index "mappings", ["user_id"], name: "index_mappings_on_user_id", using: :btree

  create_table "odk_sf_legacy_imports", force: true do |t|
    t.string   "odk_formid"
    t.string   "last_uuid"
    t.text     "cursor"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "num_imported", default: 0
    t.integer  "mapping_id"
  end

  add_index "odk_sf_legacy_imports", ["mapping_id"], name: "index_odk_sf_legacy_imports_on_mapping_id", using: :btree

  create_table "odk_sf_legacy_mappings", force: true do |t|
    t.string   "name"
    t.string   "odk_formid"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "active",     default: false
    t.integer  "user_id"
    t.boolean  "enabled"
  end

  add_index "odk_sf_legacy_mappings", ["user_id"], name: "index_odk_sf_legacy_mappings_on_user_id", using: :btree

  create_table "odk_sf_legacy_odk_fields", force: true do |t|
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

  add_index "odk_sf_legacy_odk_fields", ["odk_form_id"], name: "index_odk_sf_legacy_odk_fields_on_odk_form_id", using: :btree

  create_table "odk_sf_legacy_odk_forms", force: true do |t|
    t.string   "name"
    t.integer  "mapping_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "odk_sf_legacy_odk_forms", ["mapping_id"], name: "index_odk_sf_legacy_odk_forms_on_mapping_id", using: :btree

  create_table "odk_sf_legacy_salesforce_fields", force: true do |t|
    t.string   "field_name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "data_type"
    t.string   "label_name"
    t.string   "color"
    t.boolean  "is_lookup",            default: false
    t.integer  "salesforce_object_id"
    t.string   "reference_to"
    t.boolean  "nillable"
    t.boolean  "unique"
    t.json     "properties"
  end

  add_index "odk_sf_legacy_salesforce_fields", ["salesforce_object_id"], name: "index_odk_sf_legacy_salesforce_fields_on_salesforce_object_id", using: :btree

  create_table "odk_sf_legacy_salesforce_objects", force: true do |t|
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

  add_index "odk_sf_legacy_salesforce_objects", ["mapping_id"], name: "index_odk_sf_legacy_salesforce_objects_on_mapping_id", using: :btree

  create_table "odk_sf_legacy_submissions", force: true do |t|
    t.string   "uuid"
    t.string   "state"
    t.json     "data"
    t.integer  "import_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "message"
    t.text     "backtrace"
    t.json     "media_data"
  end

  create_table "organizations", force: true do |t|
    t.integer  "plan_id"
    t.integer  "credits",                   default: 0
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "stripe_customer_token"
    t.string   "stripe_subscription_token"
    t.string   "stripe_current_period_end"
  end

  add_index "organizations", ["plan_id"], name: "index_organizations_on_plan_id", using: :btree

  create_table "plans", force: true do |t|
    t.string   "name"
    t.decimal  "price"
    t.integer  "project_limit"
    t.integer  "user_limit"
    t.integer  "connected_app_limit"
    t.integer  "map_limit"
    t.string   "support_type"
    t.integer  "job_limit"
    t.string   "sync_interval"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "products", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.string   "salesforce_id"
    t.string   "website"
    t.boolean  "enabled"
    t.boolean  "integrated",           default: false
    t.text     "costs"
    t.text     "reviews"
    t.text     "resources"
    t.text     "provider"
    t.text     "detailed_description"
    t.string   "update_link"
    t.string   "integration_type"
    t.boolean  "detail_active"
    t.text     "tech_specs"
    t.string   "sf_link"
    t.string   "twitter"
    t.string   "email"
    t.string   "facebook"
    t.integer  "draft_id"
    t.datetime "published_at"
    t.datetime "trashed_at"
  end

  create_table "projects", force: true do |t|
    t.integer  "organization_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "projects", ["organization_id"], name: "index_projects_on_organization_id", using: :btree

  create_table "review_votes", force: true do |t|
    t.integer  "user_id"
    t.integer  "review_id"
    t.integer  "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "review_votes", ["review_id"], name: "index_review_votes_on_review_id", using: :btree
  add_index "review_votes", ["user_id"], name: "index_review_votes_on_user_id", using: :btree

  create_table "reviews", force: true do |t|
    t.integer  "user_id"
    t.integer  "product_id"
    t.string   "review"
    t.float    "rating"
    t.date     "date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "reviews", ["product_id"], name: "index_reviews_on_product_id", using: :btree
  add_index "reviews", ["user_id"], name: "index_reviews_on_user_id", using: :btree

  create_table "submission_records", force: true do |t|
    t.integer  "mapping_id"
    t.text     "raw_source_payload"
    t.text     "raw_destination_payload"
    t.datetime "processed_at"
    t.json     "source_payload"
    t.json     "destination_payload"
  end

  create_table "tag_categories", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "taggings", force: true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       limit: 128
    t.datetime "created_at"
    t.integer  "draft_id"
    t.datetime "published_at"
    t.datetime "trashed_at"
  end

  add_index "taggings", ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true, using: :btree
  add_index "taggings", ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context", using: :btree

  create_table "tags", force: true do |t|
    t.string  "name"
    t.integer "taggings_count",  default: 0
    t.integer "tag_category_id"
  end

  add_index "tags", ["name"], name: "index_tags_on_name", unique: true, using: :btree
  add_index "tags", ["tag_category_id"], name: "index_tags_on_tag_category_id", using: :btree

  create_table "team_members", force: true do |t|
    t.string  "name"
    t.text    "bio"
    t.string  "picture_url"
    t.integer "order"
    t.string  "title"
  end

  create_table "users", force: true do |t|
    t.string   "email",                                           null: false
    t.string   "crypted_password",                                null: false
    t.string   "salt",                                            null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "sf_username"
    t.string   "sf_password"
    t.string   "odk_url"
    t.string   "sf_security_token"
    t.boolean  "valid_credentials",               default: false
    t.string   "sf_app_secret"
    t.string   "sf_app_key"
    t.string   "odk_username"
    t.string   "odk_password"
    t.string   "sf_host"
    t.string   "role"
    t.integer  "credits",                         default: 0
    t.string   "first_name"
    t.string   "last_name"
    t.string   "organisation"
    t.integer  "organization_id"
    t.string   "invitation_token"
    t.string   "stripe_customer_token"
    t.string   "stripe_subscription_token"
    t.integer  "plan_id"
    t.datetime "stripe_current_period_end"
    t.string   "reset_password_token"
    t.datetime "reset_password_token_expires_at"
    t.datetime "reset_password_email_sent_at"
    t.boolean  "unlimited",                       default: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["organization_id"], name: "index_users_on_organization_id", using: :btree
  add_index "users", ["plan_id"], name: "index_users_on_plan_id", using: :btree

  create_table "votes", force: true do |t|
    t.integer  "user_id"
    t.integer  "product_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
