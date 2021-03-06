# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20100903153704) do

  create_table "comments", :force => true do |t|
    t.text     "content"
    t.integer  "user_id"
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "approved",         :default => true
  end

  create_table "counties", :force => true do |t|
    t.string   "name"
    t.string   "code"
    t.integer  "numeric_code"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "events", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "images", :force => true do |t|
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "file_name"
    t.integer  "file_size"
    t.string   "file_type"
    t.integer  "height"
    t.integer  "width"
    t.binary   "file_content", :limit => 16777215
  end

  create_table "menu_node_side_modules", :force => true do |t|
    t.integer  "menu_node_id"
    t.integer  "side_module_id"
    t.boolean  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "position_y"
  end

  create_table "menu_nodes", :force => true do |t|
    t.string   "title"
    t.string   "url"
    t.integer  "position"
    t.integer  "parent_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "viewable"
    t.string   "side_module_regex"
  end

  create_table "municipalities", :force => true do |t|
    t.string   "name"
    t.integer  "code"
    t.integer  "county_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "notes", :force => true do |t|
    t.text     "content"
    t.integer  "noteable_id"
    t.string   "noteable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pages", :force => true do |t|
    t.string   "title"
    t.string   "permalink"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "public"
    t.text     "style"
  end

  create_table "points", :force => true do |t|
    t.float    "latitude"
    t.float    "longitude"
    t.float    "elevation"
    t.integer  "tracksegment_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "races", :force => true do |t|
    t.integer  "event_id"
    t.float    "distance"
    t.time     "time"
    t.integer  "hr_max"
    t.integer  "hr_avg"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "training_id"
    t.integer  "track_id"
  end

  create_table "side_modules", :force => true do |t|
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "style"
    t.string   "title"
  end

  create_table "taggings", :force => true do |t|
    t.integer  "track_id"
    t.integer  "tag_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tags", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tracks", :force => true do |t|
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "date"
    t.text     "description"
    t.integer  "municipality_id"
    t.integer  "created_by_user_id"
    t.decimal  "distance",                               :precision => 7, :scale => 3
    t.string   "file_name"
    t.integer  "file_size"
    t.string   "file_type"
    t.binary   "file_content",       :limit => 16777215
  end

  create_table "tracksegments", :force => true do |t|
    t.integer  "track_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "track_version"
  end

  create_table "trainings", :force => true do |t|
    t.date     "date"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "login",                     :limit => 40
    t.string   "name",                      :limit => 100, :default => ""
    t.string   "email",                     :limit => 100
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token",            :limit => 40
    t.datetime "remember_token_expires_at"
    t.string   "identity_url"
    t.integer  "birthday_year"
    t.boolean  "admin"
    t.datetime "last_login_at"
    t.string   "last_login_ip"
    t.integer  "municipality_id"
    t.boolean  "gender"
  end

  add_index "users", ["login"], :name => "index_users_on_login", :unique => true

  create_table "versions", :force => true do |t|
    t.integer  "versioned_id"
    t.string   "versioned_type"
    t.integer  "user_id"
    t.string   "user_type"
    t.string   "user_name"
    t.text     "changes"
    t.integer  "number"
    t.string   "tag"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "versions", ["created_at"], :name => "index_versions_on_created_at"
  add_index "versions", ["number"], :name => "index_versions_on_number"
  add_index "versions", ["tag"], :name => "index_versions_on_tag"
  add_index "versions", ["user_id", "user_type"], :name => "index_versions_on_user_id_and_user_type"
  add_index "versions", ["user_name"], :name => "index_versions_on_user_name"
  add_index "versions", ["versioned_id", "versioned_type"], :name => "index_versions_on_versioned_id_and_versioned_type"

end
