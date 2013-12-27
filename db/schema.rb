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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130411083102) do

  create_table "activities", :force => true do |t|
    t.string   "title"
    t.integer  "need_score",                                        :default => 0
    t.decimal  "real_money",          :precision => 8, :scale => 1
    t.integer  "total_number",                                      :default => 0
    t.datetime "end_time"
    t.string   "description"
    t.datetime "created_at",                                                       :null => false
    t.datetime "updated_at",                                                       :null => false
    t.integer  "join_number",                                       :default => 0
    t.datetime "start_time"
    t.integer  "is_locked",                                         :default => 0
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
  end

  create_table "activities_users", :force => true do |t|
    t.integer  "user_id"
    t.integer  "activity_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "admins", :force => true do |t|
    t.string   "name"
    t.integer  "role"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.string   "password_digest"
  end

  add_index "admins", ["name"], :name => "index_admins_on_name", :unique => true

  create_table "ads", :force => true do |t|
    t.string   "img_path"
    t.string   "link_to",         :default => "/"
    t.integer  "ad_type",         :default => 1
    t.integer  "order_number",    :default => 0
    t.time     "expiration_time"
    t.integer  "money",           :default => 0
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
    t.string   "title",           :default => ""
    t.string   "status",          :default => ""
    t.integer  "school_id"
    t.string   "describe"
    t.integer  "store_id"
  end

  create_table "applications", :force => true do |t|
    t.string   "tel"
    t.string   "user_name"
    t.string   "address"
    t.text     "about_store"
    t.integer  "status",      :default => 0
    t.integer  "user_id"
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
    t.string   "store_name"
  end

  add_index "applications", ["user_id"], :name => "index_applications_on_user_id"

  create_table "carts", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "store_id"
  end

  create_table "categories", :force => true do |t|
    t.string   "name"
    t.integer  "sortvalue"
    t.integer  "store_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "categories", ["store_id"], :name => "index_categories_on_store_id"

  create_table "complaint_replies", :force => true do |t|
    t.integer  "super_man_id"
    t.integer  "complaint_id"
    t.string   "content"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "complaints", :force => true do |t|
    t.integer  "user_id"
    t.string   "order_number"
    t.string   "target"
    t.string   "content"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.integer  "has_replied"
  end

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "exchange_goods", :force => true do |t|
    t.string   "name"
    t.string   "image_url_file_name"
    t.integer  "least_integral"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
  end

  create_table "favorite_foods", :force => true do |t|
    t.integer  "user_id"
    t.integer  "food_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "favorites", :force => true do |t|
    t.integer  "user_id"
    t.integer  "store_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "food_senters", :force => true do |t|
    t.string   "login_name"
    t.string   "password"
    t.string   "user_name"
    t.string   "id_number"
    t.string   "tel"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "user_type"
    t.integer  "is_work"
  end

  create_table "foods", :force => true do |t|
    t.string   "name"
    t.float    "price"
    t.integer  "sum"
    t.string   "tag"
    t.integer  "energy"
    t.float    "rank"
    t.float    "sales"
    t.integer  "store_id"
    t.integer  "category_id"
    t.datetime "created_at",                            :null => false
    t.datetime "updated_at",                            :null => false
    t.string   "vmeal_category_name"
    t.string   "photo_file_name"
    t.integer  "sales_count",           :default => 0
    t.integer  "comment_number",        :default => 1
    t.integer  "comment_score",         :default => 4
    t.integer  "is_ad",                 :default => 0
    t.integer  "sent_time",             :default => 18
    t.string   "ingredients"
    t.integer  "is_recommend",          :default => 0
    t.string   "recomment_description"
  end

  add_index "foods", ["category_id"], :name => "index_foods_on_category_id"
  add_index "foods", ["store_id"], :name => "index_foods_on_store_id"

  create_table "good_addresses", :force => true do |t|
    t.string   "real_name"
    t.string   "address"
    t.string   "tel_number"
    t.string   "zip_code"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "integral_consumer_records", :force => true do |t|
    t.integer  "user_id"
    t.integer  "exchange_goods_id"
    t.integer  "number"
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
    t.string   "address"
    t.string   "phone"
    t.string   "phone_bk"
    t.string   "name"
    t.integer  "status",            :default => 0
  end

  create_table "line_items", :force => true do |t|
    t.integer  "food_id"
    t.integer  "cart_id"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
    t.integer  "quantity",   :default => 1
    t.integer  "order_id"
    t.integer  "rank",       :default => 3
    t.string   "content"
  end

  create_table "mail_index_users", :force => true do |t|
    t.integer  "send_user_id"
    t.integer  "receiver_user_id"
    t.integer  "mail_id"
    t.integer  "send_status",      :default => 0
    t.integer  "receive_status",   :default => 0
    t.integer  "read_status",      :default => 0
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
  end

  create_table "messages", :force => true do |t|
    t.string   "comment"
    t.integer  "user_id"
    t.integer  "store_id"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
    t.integer  "is_locked",  :default => 0
  end

  create_table "notices", :force => true do |t|
    t.string   "title"
    t.text     "content"
    t.integer  "priority"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "order_periods", :force => true do |t|
    t.string   "start_time"
    t.string   "end_time"
    t.string   "description"
    t.integer  "max_number"
    t.integer  "store_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "orders", :force => true do |t|
    t.string   "address"
    t.string   "phone"
    t.string   "name"
    t.string   "order_number"
    t.string   "pay_type",       :default => "货到付款"
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
    t.text     "comment"
    t.integer  "user_id"
    t.integer  "order_status",   :default => 0
    t.integer  "food_senter_id"
    t.integer  "is_comment",     :default => 0
    t.integer  "is_complainted", :default => 0
    t.integer  "store_id"
    t.string   "phone_bk"
    t.integer  "rank"
    t.string   "fail_comment"
    t.string   "send_time",      :default => "立即送出"
  end

  create_table "peak_order_periods", :force => true do |t|
    t.time     "start_time"
    t.time     "end_time"
    t.integer  "order_period_id"
    t.integer  "max_number"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "qingans", :force => true do |t|
    t.string   "name"
    t.string   "telephone"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "replies", :force => true do |t|
    t.string   "comment"
    t.integer  "message_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "schools", :force => true do |t|
    t.string   "name",                :default => ""
    t.string   "short_name",          :default => ""
    t.datetime "created_at",                          :null => false
    t.datetime "updated_at",                          :null => false
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
  end

  create_table "score_histories", :force => true do |t|
    t.integer  "user_id"
    t.string   "operate"
    t.string   "detail"
    t.integer  "change_score", :default => 0
    t.integer  "change_type",  :default => 0
    t.integer  "activity_id"
    t.datetime "created_at",                  :null => false
    t.datetime "updated_at",                  :null => false
  end

  add_index "score_histories", ["change_type"], :name => "index_score_histories_on_change_type"

  create_table "season_foods", :force => true do |t|
    t.string   "image_url_file_name"
    t.string   "introduction"
    t.text     "content"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
    t.string   "title"
  end

  create_table "send_addresses", :force => true do |t|
    t.string   "address"
    t.string   "tel_number1"
    t.string   "tel_number2"
    t.integer  "user_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.string   "name"
  end

  add_index "send_addresses", ["user_id"], :name => "index_send_addresses_on_user_id"

  create_table "short_phones", :force => true do |t|
    t.string   "phone_number"
    t.integer  "store_id"
    t.text     "content"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "station_mails", :force => true do |t|
    t.string   "title"
    t.text     "content"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "sto_categories", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "store_users", :force => true do |t|
    t.string   "username"
    t.string   "password"
    t.integer  "store_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "stores", :force => true do |t|
    t.string   "name"
    t.string   "introduce"
    t.string   "address"
    t.time     "opentime"
    t.time     "closetime"
    t.string   "tags"
    t.string   "categore"
    t.string   "tel"
    t.integer  "isclose",                                            :default => 0
    t.decimal  "send_price",          :precision => 6,  :scale => 2
    t.decimal  "rank",                :precision => 10, :scale => 0
    t.datetime "settledtime"
    t.datetime "created_at",                                                         :null => false
    t.datetime "updated_at",                                                         :null => false
    t.string   "image_url_file_name"
    t.integer  "user_id"
    t.integer  "sent_time",                                          :default => 20
    t.string   "main_sales"
    t.string   "public_talk"
    t.integer  "sum_comment",                                        :default => 1
    t.integer  "sum_score",                                          :default => 4
    t.integer  "is_super_market",                                    :default => 0
    t.integer  "isphone",                                            :default => 0
    t.integer  "sortvalue",                                          :default => 0
    t.integer  "delivery_charge",                                    :default => 0
    t.integer  "school_id"
  end

  create_table "super_men", :force => true do |t|
    t.string   "user_name"
    t.string   "password"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
    t.integer  "user_type",  :default => 0
    t.string   "number"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.string   "username"
    t.integer  "integral",               :default => 0
    t.integer  "is_store",               :default => 0
    t.integer  "is_locked",              :default => 0
    t.integer  "default_address_id",     :default => -1
    t.string   "image_url_file_name"
    t.string   "uid"
    t.integer  "is_ok",                  :default => 0
    t.integer  "good_address_id"
  end

  create_table "vmails", :force => true do |t|
    t.string   "title"
    t.text     "content"
    t.string   "sent_mails"
    t.integer  "admin_id"
    t.integer  "is_send"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "vmeal_categores", :force => true do |t|
    t.string   "name"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
    t.string   "image_url_file_name"
  end

end
