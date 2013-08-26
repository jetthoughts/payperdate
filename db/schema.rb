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

ActiveRecord::Schema.define(version: 20130823100753) do

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
    t.string   "email",                      default: "",    null: false
    t.string   "encrypted_password",         default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",              default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "master"
    t.boolean  "permission_approver"
    t.boolean  "permission_customer_care"
    t.boolean  "permission_login_as_user",   default: false, null: false
    t.boolean  "permission_gifts_and_winks"
    t.boolean  "permission_mass_mailing"
    t.boolean  "permission_accounting"
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

  create_table "block_relationships", force: true do |t|
    t.integer  "user_id"
    t.integer  "target_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "block_relationships", ["target_id"], name: "index_block_relationships_on_target_id", using: :btree
  add_index "block_relationships", ["user_id"], name: "index_block_relationships_on_user_id", using: :btree

  create_table "communication_costs", force: true do |t|
    t.integer  "start_amount_cents",    default: 0,     null: false
    t.string   "start_amount_currency", default: "USD", null: false
    t.integer  "end_amount_cents",      default: 0,     null: false
    t.string   "end_amount_currency",   default: "USD", null: false
    t.integer  "cost"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "credits_packages", force: true do |t|
    t.integer  "price_cents",    default: 0,     null: false
    t.string   "price_currency", default: "USD", null: false
    t.integer  "credits"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "date_ranks", force: true do |t|
    t.integer  "user_id",              null: false
    t.integer  "users_date_id",        null: false
    t.integer  "courtesy_rank_id",     null: false
    t.integer  "punctuality_rank_id",  null: false
    t.integer  "authenticity_rank_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "date_ranks", ["authenticity_rank_id"], name: "index_date_ranks_on_authenticity_rank_id", using: :btree
  add_index "date_ranks", ["courtesy_rank_id"], name: "index_date_ranks_on_courtesy_rank_id", using: :btree
  add_index "date_ranks", ["punctuality_rank_id"], name: "index_date_ranks_on_punctuality_rank_id", using: :btree
  add_index "date_ranks", ["user_id"], name: "index_date_ranks_on_user_id", using: :btree
  add_index "date_ranks", ["users_date_id"], name: "index_date_ranks_on_users_date_id", using: :btree

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

  create_table "gift_templates", force: true do |t|
    t.string   "image",                          null: false
    t.string   "state",      default: "enabled", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.integer  "cost",       default: 0,         null: false
  end

  create_table "gifts", force: true do |t|
    t.integer  "gift_template_id"
    t.integer  "user_id"
    t.integer  "recipient_id"
    t.string   "comment"
    t.boolean  "private",          default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "gifts", ["gift_template_id"], name: "index_gifts_on_gift_template_id", using: :btree
  add_index "gifts", ["recipient_id"], name: "index_gifts_on_recipient_id", using: :btree
  add_index "gifts", ["user_id"], name: "index_gifts_on_user_id", using: :btree

  create_table "invitations", force: true do |t|
    t.string   "message"
    t.integer  "amount_cents",           default: 0,         null: false
    t.string   "amount_currency",        default: "USD",     null: false
    t.integer  "user_id",                                    null: false
    t.integer  "invited_user_id",                            null: false
    t.boolean  "counter",                default: false,     null: false
    t.string   "state",                  default: "pending", null: false
    t.string   "reject_reason"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "communication_unlocked", default: false
  end

  add_index "invitations", ["invited_user_id", "counter"], name: "index_invitations_on_invited_user_id_and_counter", using: :btree
  add_index "invitations", ["user_id", "counter"], name: "index_invitations_on_user_id_and_counter", using: :btree

  create_table "member_reports", force: true do |t|
    t.integer  "user_id",                             null: false
    t.integer  "reported_user_id",                    null: false
    t.integer  "content_id",                          null: false
    t.string   "content_type",                        null: false
    t.string   "message",                             null: false
    t.string   "state",            default: "active", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "member_reports", ["content_id", "content_type"], name: "index_member_reports_on_content_id_and_content_type", using: :btree
  add_index "member_reports", ["reported_user_id"], name: "index_member_reports_on_reported_user_id", using: :btree
  add_index "member_reports", ["user_id"], name: "index_member_reports_on_user_id", using: :btree

  create_table "messages", force: true do |t|
    t.integer  "sender_id",                        null: false
    t.integer  "recipient_id",                     null: false
    t.text     "content",                          null: false
    t.string   "recipient_state",                  null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "sender_state",    default: "sent", null: false
  end

  add_index "messages", ["recipient_id"], name: "index_messages_on_recipient_id", using: :btree
  add_index "messages", ["sender_id"], name: "index_messages_on_sender_id", using: :btree

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

  create_table "profile_multiselects", force: true do |t|
    t.integer  "profile_id"
    t.string   "name"
    t.string   "select_type"
    t.string   "value"
    t.boolean  "checked"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "profile_notes", force: true do |t|
    t.string   "text",          null: false
    t.integer  "profile_id",    null: false
    t.integer  "admin_user_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "profile_notes", ["profile_id"], name: "index_profile_notes_on_profile_id", using: :btree

  create_table "profiles", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
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
    t.string   "date_preferences_accepted_distance"
    t.string   "date_preferences_accepted_distance_do_care"
    t.text     "date_preferences_description"
    t.string   "optional_info_education"
    t.string   "optional_info_occupation"
    t.string   "optional_info_annual_income"
    t.string   "optional_info_net_worth"
    t.string   "optional_info_height"
    t.string   "optional_info_body_type"
    t.string   "optional_info_religion"
    t.string   "optional_info_ethnicity"
    t.string   "optional_info_eye_color"
    t.string   "optional_info_hair_color"
    t.string   "optional_info_children"
    t.string   "optional_info_smoker"
    t.string   "optional_info_drinker"
    t.date     "optional_info_birthday"
    t.string   "nickname_cache"
    t.string   "name_cache"
  end

  create_table "ranks", force: true do |t|
    t.string   "name",       null: false
    t.integer  "value",      null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "services", force: true do |t|
    t.string   "key"
    t.string   "name"
    t.integer  "cost",        default: 0, null: false
    t.boolean  "use_credits"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "transactions", force: true do |t|
    t.integer  "trackable_id"
    t.string   "trackable_type"
    t.integer  "owner_id"
    t.string   "owner_type"
    t.integer  "recipient_id"
    t.string   "recipient_type"
    t.integer  "amount"
    t.string   "key"
    t.string   "error"
    t.string   "state",          default: "pending", null: false
    t.string   "transaction_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "transactions", ["owner_id", "owner_type"], name: "index_transactions_on_owner_id_and_owner_type", using: :btree
  add_index "transactions", ["recipient_id", "recipient_type"], name: "index_transactions_on_recipient_id_and_recipient_type", using: :btree
  add_index "transactions", ["trackable_id", "trackable_type"], name: "index_transactions_on_trackable_id_and_trackable_type", using: :btree

  create_table "users", force: true do |t|
    t.string   "email",                             default: "",       null: false
    t.string   "encrypted_password",                default: "",       null: false
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
    t.string   "nickname",                                             null: false
    t.string   "name",                                                 null: false
    t.string   "phone",                  limit: 20
    t.boolean  "no_password",                       default: false,    null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "published_profile_id"
    t.integer  "profile_id"
    t.boolean  "subscribed",                        default: true
    t.string   "state",                             default: "active"
    t.integer  "avatar_id"
    t.integer  "credits_amount",                    default: 0,        null: false
    t.string   "deleted_reason"
    t.string   "deleted_state",                     default: "none"
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["nickname"], name: "index_users_on_nickname", unique: true, using: :btree
  add_index "users", ["phone"], name: "index_users_on_phone", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "users_dates", force: true do |t|
    t.integer  "owner_id"
    t.integer  "recipient_id"
    t.boolean  "unlocked",     default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users_dates", ["owner_id", "recipient_id"], name: "index_users_dates_on_owner_id_and_recipient_id", unique: true, using: :btree

  create_table "wink_templates", force: true do |t|
    t.string   "name",                       null: false
    t.string   "image",                      null: false
    t.boolean  "disabled",   default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "wink_templates", ["name"], name: "index_wink_templates_on_name", unique: true, using: :btree

  create_table "winks", force: true do |t|
    t.integer  "wink_template_id", null: false
    t.integer  "user_id",          null: false
    t.integer  "recipient_id",     null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "winks", ["recipient_id"], name: "index_winks_on_recipient_id", using: :btree
  add_index "winks", ["user_id"], name: "index_winks_on_user_id", using: :btree
  add_index "winks", ["wink_template_id"], name: "index_winks_on_wink_template_id", using: :btree

end
