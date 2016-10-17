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

ActiveRecord::Schema.define(version: 20161010052651) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accounts", force: :cascade do |t|
    t.text     "description"
    t.integer  "customer_id"
    t.integer  "sic_id"
    t.integer  "status_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.integer  "user_id"
    t.datetime "effective_date"
    t.index ["customer_id"], name: "index_accounts_on_customer_id", using: :btree
    t.index ["sic_id"], name: "index_accounts_on_sic_id", using: :btree
    t.index ["status_id"], name: "index_accounts_on_status_id", using: :btree
    t.index ["user_id"], name: "index_accounts_on_user_id", using: :btree
  end

  create_table "coverages", force: :cascade do |t|
    t.integer  "deductible"
    t.integer  "deductible_percent"
    t.integer  "limit"
    t.integer  "quote_id"
    t.integer  "wording_id"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.index ["quote_id"], name: "index_coverages_on_quote_id", using: :btree
    t.index ["wording_id"], name: "index_coverages_on_wording_id", using: :btree
  end

  create_table "customers", force: :cascade do |t|
    t.string   "name"
    t.string   "address"
    t.string   "phone"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "insurers", force: :cascade do |t|
    t.string   "name"
    t.string   "am_best_rating"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "quotes", force: :cascade do |t|
    t.string   "pdf"
    t.string   "csv"
    t.integer  "insurer_id"
    t.integer  "account_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "policy"
    t.integer  "premium"
    t.index ["account_id"], name: "index_quotes_on_account_id", using: :btree
    t.index ["insurer_id"], name: "index_quotes_on_insurer_id", using: :btree
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

  create_table "statuses", force: :cascade do |t|
    t.string   "name"
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

  create_table "wording_aliases", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "section_id"
    t.text     "description"
    t.string   "irmi"
    t.index ["section_id"], name: "index_wording_aliases_on_section_id", using: :btree
  end

  create_table "wordings", force: :cascade do |t|
    t.string   "form"
    t.string   "name"
    t.text     "verbiage"
    t.integer  "insurer_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.integer  "wording_alias_id"
    t.index ["insurer_id"], name: "index_wordings_on_insurer_id", using: :btree
    t.index ["wording_alias_id"], name: "index_wordings_on_wording_alias_id", using: :btree
  end

  add_foreign_key "accounts", "customers"
  add_foreign_key "accounts", "sics"
  add_foreign_key "accounts", "statuses"
  add_foreign_key "accounts", "users"
  add_foreign_key "coverages", "quotes"
  add_foreign_key "coverages", "wordings"
  add_foreign_key "quotes", "accounts"
  add_foreign_key "quotes", "insurers"
  add_foreign_key "section_aliases", "insurers"
  add_foreign_key "section_aliases", "sections"
  add_foreign_key "wording_aliases", "sections"
  add_foreign_key "wordings", "insurers"
  add_foreign_key "wordings", "wording_aliases"
end
