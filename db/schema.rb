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

ActiveRecord::Schema.define(version: 20160919233827) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "insurers", force: :cascade do |t|
    t.string   "name"
    t.string   "am_best_rating"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "section_aliases", force: :cascade do |t|
    t.string   "name"
    t.integer  "section_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "insurer_id"
    t.index ["insurer_id"], name: "index_section_aliases_on_insurer_id", using: :btree
    t.index ["section_id"], name: "index_section_aliases_on_section_id", using: :btree
  end

  create_table "sections", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sics", force: :cascade do |t|
    t.integer  "code"
    t.string   "name"
    t.string   "segment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email"
    t.string   "title"
    t.string   "company"
    t.string   "phone"
    t.boolean  "admin"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.string   "password_digest"
    t.string   "first_name"
    t.string   "last_name"
  end

  create_table "wordings", force: :cascade do |t|
    t.string   "form"
    t.string   "name"
    t.text     "verbiage"
    t.integer  "insurer_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["insurer_id"], name: "index_wordings_on_insurer_id", using: :btree
  end

  add_foreign_key "section_aliases", "insurers"
  add_foreign_key "section_aliases", "sections"
  add_foreign_key "wordings", "insurers"
end
