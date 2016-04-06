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

ActiveRecord::Schema.define(version: 20160406211623) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "companies", force: :cascade do |t|
    t.string   "name"
    t.string   "description"
    t.string   "lead_source"
    t.string   "job_types"
    t.string   "website"
    t.integer  "monthly_total"
    t.string   "address"
    t.boolean  "lost"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "contacts", force: :cascade do |t|
    t.integer  "company_id"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "phone"
    t.string   "mobile"
    t.string   "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "contacts", ["company_id"], name: "index_contacts_on_company_id", using: :btree

  create_table "social_ids", force: :cascade do |t|
    t.integer  "company_id"
    t.string   "facebook_id"
    t.string   "google_analytics_id"
    t.string   "linkedin_id"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
  end

  add_index "social_ids", ["company_id"], name: "index_social_ids_on_company_id", using: :btree

  create_table "time_trackings", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "company_id"
    t.decimal  "spent_time"
    t.decimal  "hourly_rate"
    t.date     "date"
    t.text     "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "time_trackings", ["company_id"], name: "index_time_trackings_on_company_id", using: :btree
  add_index "time_trackings", ["user_id"], name: "index_time_trackings_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.string   "password_digest"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.boolean  "admin",           default: false
  end

  add_foreign_key "contacts", "companies"
  add_foreign_key "social_ids", "companies"
  add_foreign_key "time_trackings", "companies"
  add_foreign_key "time_trackings", "users"
end
