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

ActiveRecord::Schema.define(version: 20140704161711) do

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
  end

  create_table "odk_fields", force: true do |t|
    t.string   "field_name"
    t.string   "field_type"
    t.integer  "salesforce_field_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "salesforce_fields", force: true do |t|
    t.integer  "mapping_id"
    t.string   "object_name"
    t.string   "field_name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "data_type"
    t.string   "label_name"
    t.boolean  "perform_lookups", default: false
  end

  create_table "users", force: true do |t|
    t.string   "email",            null: false
    t.string   "crypted_password", null: false
    t.string   "salt",             null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree

end
