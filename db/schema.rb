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

ActiveRecord::Schema.define(:version => 20120406144731) do

  create_table "authors", :force => true do |t|
    t.string   "uid",        :default => "",    :null => false
    t.string   "name",       :default => "",    :null => false
    t.string   "email",      :default => "",    :null => false
    t.string   "image",      :default => "",    :null => false
    t.string   "provider",   :default => "",    :null => false
    t.boolean  "negative",   :default => false
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  create_table "movies", :force => true do |t|
    t.string   "name_of_original",   :default => "",    :null => false
    t.string   "name_of_japan",      :default => "",    :null => false
    t.string   "name_of_japan_kana", :default => "",    :null => false
    t.string   "name_of_english",    :default => ""
    t.string   "image",              :default => ""
    t.integer  "show_time",                             :null => false
    t.text     "outline",                               :null => false
    t.date     "open_date"
    t.string   "category",           :default => ""
    t.boolean  "negative",           :default => false
    t.datetime "created_at",                            :null => false
    t.datetime "updated_at",                            :null => false
  end

  create_table "sample1s", :force => true do |t|
    t.string   "hoge"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "samples", :force => true do |t|
    t.string   "hoge"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "seens", :force => true do |t|
    t.integer  "movie_id"
    t.integer  "author_id"
    t.date     "date"
    t.string   "acondition", :default => ""
    t.text     "comment"
    t.string   "evaluation", :default => ""
    t.boolean  "negative",   :default => false
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  create_table "tags", :force => true do |t|
    t.string   "name",        :default => "",    :null => false
    t.boolean  "attrib",      :default => false
    t.integer  "belong",      :default => 0
    t.integer  "order_by",    :default => 0
    t.string   "match_table", :default => ""
    t.boolean  "negative",    :default => false
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
  end

end
