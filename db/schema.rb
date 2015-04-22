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

ActiveRecord::Schema.define(version: 20150422132910) do

  create_table "buckets", force: :cascade do |t|
    t.integer  "bucket_type",   default: 0
    t.integer  "temperature",   default: 50
    t.integer  "visibility",    default: 0
    t.boolean  "locked",        default: true
    t.integer  "user_id"
    t.string   "title"
    t.string   "description"
    t.date     "when_datetime"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  create_table "drops", force: :cascade do |t|
    t.string   "media_key"
    t.string   "caption"
    t.integer  "parent_id"
    t.integer  "bucket_id"
    t.integer  "user_id"
    t.integer  "lft",        null: false
    t.integer  "rgt",        null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "drops", ["lft"], name: "index_drops_on_lft"
  add_index "drops", ["parent_id"], name: "index_drops_on_parent_id"
  add_index "drops", ["rgt"], name: "index_drops_on_rgt"

  create_table "user_sessions", force: :cascade do |t|
    t.string   "auth_token"
    t.integer  "user_id"
    t.string   "device_id"
    t.integer  "device_type"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "user_sessions", ["user_id"], name: "index_user_sessions_on_user_id"

  create_table "users", force: :cascade do |t|
    t.string   "username"
    t.string   "email"
    t.integer  "phone_number"
    t.string   "display_name"
    t.integer  "availability",     default: 0
    t.string   "password_hash"
    t.string   "password_salt"
    t.boolean  "private_profile",  default: false
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.string   "sns_endpoint_arn"
  end

end
