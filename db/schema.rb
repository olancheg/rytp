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

ActiveRecord::Schema.define(:version => 20110822080120) do

  create_table "authentications", :force => true do |t|
    t.integer  "user_id"
    t.string   "provider"
    t.string   "uid"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "authentications", ["user_id"], :name => "index_authentications_on_user_id"

  create_table "categories", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "contests", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.date     "start_at"
    t.date     "end_at"
    t.integer  "first_place"
    t.integer  "second_place"
    t.integer  "third_place"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "favourites", :force => true do |t|
    t.integer  "user_id"
    t.integer  "poop_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "favourites", ["poop_id"], :name => "index_favourites_on_poop_id"
  add_index "favourites", ["user_id"], :name => "index_favourites_on_user_id"

  create_table "news", :force => true do |t|
    t.string   "title"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  add_index "news", ["user_id"], :name => "index_news_on_user_id"

  create_table "poops", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.text     "code"
    t.boolean  "approved",    :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "category_id"
    t.integer  "rating",      :default => 0
    t.integer  "votes_count", :default => 0
    t.integer  "user_id"
    t.integer  "contest_id"
  end

  add_index "poops", ["category_id"], :name => "index_poops_on_category_id"
  add_index "poops", ["contest_id"], :name => "index_poops_on_contest_id"
  add_index "poops", ["user_id"], :name => "index_poops_on_user_id"

  create_table "role_associations", :force => true do |t|
    t.integer  "user_id"
    t.integer  "role_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "role_associations", ["role_id"], :name => "index_role_associations_on_role_id"
  add_index "role_associations", ["user_id"], :name => "index_role_associations_on_user_id"

  create_table "roles", :force => true do |t|
    t.integer  "mask",       :default => 0, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name",                      :null => false
  end

  add_index "roles", ["name"], :name => "index_roles_on_name"

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "nickname"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "votes_count",                  :default => 0
    t.string   "youtube_channel"
    t.boolean  "show_profile_url",             :default => true
    t.boolean  "use_nickname_instead_of_name", :default => false
    t.string   "profile_url"
    t.integer  "poops_count",                  :default => 0
  end

  create_table "votes", :force => true do |t|
    t.boolean  "positive",   :null => false
    t.integer  "user_id"
    t.integer  "poop_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "votes", ["poop_id"], :name => "index_votes_on_poop_id"
  add_index "votes", ["user_id"], :name => "index_votes_on_user_id"

end
