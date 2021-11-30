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

ActiveRecord::Schema.define(version: 2021_11_29_081126) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "abcs", force: :cascade do |t|
    t.string "title"
    t.string "sku"
    t.integer "quantity"
    t.float "purchase_price"
    t.float "price"
    t.string "brand"
    t.string "series"
    t.boolean "check", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer "priority", default: 0, null: false
    t.integer "attempts", default: 0, null: false
    t.text "handler", null: false
    t.text "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string "locked_by"
    t.string "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["priority", "run_at"], name: "delayed_jobs_priority"
  end

  create_table "faros", force: :cascade do |t|
    t.string "title"
    t.string "sku"
    t.integer "quantity"
    t.float "purchase_price"
    t.float "price"
    t.string "brand"
    t.boolean "check", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "products", force: :cascade do |t|
    t.string "sku"
    t.string "title"
    t.string "desc"
    t.string "cat"
    t.decimal "oldprice"
    t.decimal "price"
    t.integer "quantity"
    t.string "image"
    t.string "url"
    t.bigint "insales_id"
    t.bigint "insales_var_id"
    t.string "distributor"
    t.string "p1"
    t.boolean "check", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "abc_id"
    t.bigint "faro_id"
    t.index ["abc_id"], name: "index_products_on_abc_id"
    t.index ["faro_id"], name: "index_products_on_faro_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "name", null: false
    t.string "role", default: "User"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "products", "abcs"
  add_foreign_key "products", "faros"
end
