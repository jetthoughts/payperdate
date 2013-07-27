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

ActiveRecord::Schema.define(version: 20130724165534) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "hstore"

  create_table "activities", force: true do |t|
    t.integer  "user_id"
    t.integer  "subject_id"
    t.string   "subject_type"
    t.string   "action"
    t.hstore   "details"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "admin_users", force: true do |t|
    t.string   "email",                    default: "", null: false
    t.string   "encrypted_password",       default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",            default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "master"
    t.boolean  "permission_approver"
    t.boolean  "permission_customer_care"
  end

  add_index "admin_users", ["email"], name: "index_admin_users_on_email", unique: true, using: :btree
  add_index "admin_users", ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true, using: :btree

  create_table "albums", force: true do |t|
    t.string   "name",                       null: false
    t.boolean  "system",     default: false, null: false
    t.integer  "user_id",                    null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "albums", ["name", "user_id"], name: "index_albums_on_name_and_user_id", unique: true, using: :btree
  add_index "albums", ["user_id"], name: "index_albums_on_user_id", using: :btree

  create_table "authentitications", force: true do |t|
    t.string   "provider",     null: false
    t.integer  "user_id",      null: false
    t.string   "uid",          null: false
    t.string   "access_token"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "authentitications", ["provider", "uid"], name: "index_authentitications_on_provider_and_uid", unique: true, using: :btree
  add_index "authentitications", ["user_id", "provider"], name: "index_authentitications_on_user_id_and_provider", unique: true, using: :btree

  create_table "delayed_jobs", force: true do |t|
    t.integer  "priority",   default: 0
    t.integer  "attempts",   default: 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "photos", force: true do |t|
    t.integer  "album_id",                          null: false
    t.string   "image",                             null: false
    t.integer  "verified_status", default: 0,       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "face"
    t.boolean  "nude"
    t.string   "type",            default: "Photo"
    t.integer  "declined_reason"
  end

  add_index "photos", ["album_id"], name: "index_photos_on_album_id", using: :btree

  create_table "profiles", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "avatar_id"
    t.float    "latitude"
    t.float    "longitude"
    t.boolean  "filled"
    t.string   "full_address_saved"
    t.boolean  "reviewed"
    t.string   "general_info_address_line_1"
    t.string   "general_info_address_line_2"
    t.string   "general_info_city"
    t.string   "general_info_state"
    t.string   "general_info_zip_code"
    t.string   "general_info_tagline"
    t.text     "general_info_description"
    t.string   "personal_preferences_sex"
    t.string   "personal_preferences_partners_sex"
    t.string   "personal_preferences_relationship"
    t.string   "personal_preferences_want_relationship"
    t.string   "date_preferences_accepted_distance"
    t.string   "date_preferences_accepted_distance_do_care"
    t.string   "date_preferences_smoker"
    t.string   "date_preferences_drinker"
    t.text     "date_preferences_description"
    t.integer  "optional_info_age"
    t.string   "optional_info_education"
    t.string   "optional_info_occupation"
    t.string   "optional_info_annual_income"
    t.integer  "optional_info_net_worth"
    t.integer  "optional_info_height"
    t.string   "optional_info_body_type"
    t.string   "optional_info_religion"
    t.string   "optional_info_ethnicity"
    t.string   "optional_info_eye_color"
    t.string   "optional_info_hair_color"
    t.string   "optional_info_address"
    t.string   "optional_info_children"
    t.string   "optional_info_smoker"
    t.string   "optional_info_drinker"
  end

  create_table "users", force: true do |t|
    t.string   "email",                             default: "",    null: false
    t.string   "encrypted_password",                default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                     default: 0
    t.integer  "failed_sign_in_count",              default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.string   "nickname",                                          null: false
    t.string   "name",                                              null: false
    t.string   "phone",                  limit: 20
    t.boolean  "no_password",                       default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "blocked"
    t.integer  "published_profile_id"
    t.integer  "profile_id"
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["nickname"], name: "index_users_on_nickname", unique: true, using: :btree
  add_index "users", ["phone"], name: "index_users_on_phone", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
