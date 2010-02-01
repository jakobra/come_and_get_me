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

ActiveRecord::Schema.define(:version => 20100201085533) do

  create_table "emails", :force => true do |t|
    t.string   "from"
    t.string   "to"
    t.string   "subject"
    t.text     "body"
    t.string   "attachment_file_name"
    t.string   "attachment_content_type"
    t.integer  "attachment_file_size"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "events", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "points", :force => true do |t|
    t.string   "name"
    t.float    "latitude"
    t.float    "longitude"
    t.float    "elevation"
    t.string   "description"
    t.datetime "point_created_at"
    t.integer  "tracksegment_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "position"
  end

  create_table "races", :force => true do |t|
    t.integer  "event_id"
    t.float    "distance"
    t.time     "time"
    t.integer  "max_pulse"
    t.integer  "avg_pulse"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "training_id"
    t.integer  "track_id"
  end

  create_table "tracks", :force => true do |t|
    t.string   "name"
    t.string   "track_file_name"
    t.string   "track_content_type"
    t.integer  "track_file_size"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tracksegments", :force => true do |t|
    t.integer  "track_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "start_time"
    t.datetime "end_time"
  end

  create_table "trainings", :force => true do |t|
    t.string   "title"
    t.date     "date"
    t.text     "comment"
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
  end

  add_index "users", ["login"], :name => "index_users_on_login", :unique => true

end
