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

ActiveRecord::Schema.define(:version => 20120128014610) do

  create_table "offices", :force => true do |t|
    t.string   "title"
    t.string   "state"
    t.integer  "party_id"
    t.date     "start_date"
    t.date     "end_date"
    t.integer  "perp_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "parties", :force => true do |t|
    t.string   "name"
    t.string   "three_letter"
    t.string   "one_letter"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "parties", ["name"], :name => "index_parties_on_name", :unique => true

  create_table "perps", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.integer  "party_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "statements_count", :default => 0
    t.string   "middle_name",      :default => ""
    t.string   "name_suffix",      :default => ""
    t.string   "bioguide_id"
  end

  add_index "perps", ["party_id"], :name => "index_perps_on_party_id"

  create_table "ratings", :force => true do |t|
    t.integer  "user_id"
    t.integer  "statement_id"
    t.string   "type"
    t.integer  "rating"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ratings", ["statement_id", "type"], :name => "index_ratings_on_statement_id_and_type"
  add_index "ratings", ["statement_id"], :name => "index_ratings_on_statement_id"
  add_index "ratings", ["user_id", "statement_id", "type"], :name => "index_ratings_on_user_id_and_statement_id_and_type", :unique => true
  add_index "ratings", ["user_id", "type"], :name => "index_ratings_on_user_id_and_type"
  add_index "ratings", ["user_id"], :name => "index_ratings_on_user_id"

  create_table "statements", :force => true do |t|
    t.string   "content"
    t.integer  "perp_id"
    t.date     "date"
    t.string   "primary_source"
    t.text     "context"
    t.text     "why_hypocritical"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "why_hyperbolical"
    t.integer  "hypocrisy_score"
    t.integer  "hyperbole_score"
    t.integer  "score"
    t.integer  "hypocrisy_ratings_count", :default => 0
    t.integer  "hyperbole_ratings_count", :default => 0
  end

  add_index "statements", ["hyperbole_score"], :name => "index_statements_on_hyperbole_score"
  add_index "statements", ["hypocrisy_score"], :name => "index_statements_on_hypocrisy_score"
  add_index "statements", ["perp_id"], :name => "index_statements_on_perp_id"
  add_index "statements", ["score"], :name => "index_statements_on_score"

  create_table "users", :force => true do |t|
    t.string   "handle"
    t.string   "email"
    t.string   "crypted_password"
    t.string   "password_salt"
    t.string   "persistence_token"
    t.string   "perishable_token"
    t.boolean  "admin",                   :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "hypocrisy_ratings_count", :default => 0
    t.integer  "hyperbole_ratings_count", :default => 0
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true

end
