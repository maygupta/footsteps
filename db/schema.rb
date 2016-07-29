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

ActiveRecord::Schema.define(version: 20160729033309) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "positions", force: :cascade do |t|
    t.string   "company_name"
    t.integer  "company_id"
    t.string   "title"
    t.boolean  "is_current"
    t.string   "location_name"
    t.string   "country"
    t.integer  "start_month"
    t.integer  "start_year"
    t.integer  "end_month"
    t.integer  "end_year"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.integer  "user_id"
  end

  create_table "recommendations", force: :cascade do |t|
    t.integer  "user_id"
    t.jsonb    "preferences", default: {}, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "recommendations", ["user_id"], name: "index_recommendations_on_user_id", using: :btree

  create_table "skills", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "city"
    t.string   "state"
    t.string   "address"
    t.string   "country"
    t.string   "phone_number"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.text     "access_token"
    t.string   "industry"
    t.text     "headline"
    t.text     "summary"
    t.text     "picture_url"
    t.string   "last_name"
    t.string   "maiden_name"
    t.string   "formatted_name"
    t.string   "phonetic_first_name"
    t.string   "phonetic_last_name"
    t.string   "formatted_phonetic_name"
    t.integer  "num_connections"
    t.integer  "num_connections_capped"
    t.text     "specialties"
    t.text     "public_profile_url"
    t.datetime "last_modified_timestamp"
    t.text     "proposal_comments"
    t.text     "interests"
    t.text     "languages"
    t.text     "date_of_birth"
    t.text     "jid"
    t.string   "login_type"
    t.string   "gender"
    t.text     "bg_image_url"
    t.string   "presence_status"
    t.boolean  "is_mentor"
    t.boolean  "is_verified"
    t.integer  "mentor_rating"
    t.integer  "normal_rating"
  end

end
