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

ActiveRecord::Schema.define(version: 20160325084807) do

  create_table "customers", force: true do |t|
    t.string   "name"
    t.text     "address"
    t.string   "tax_office"
    t.string   "tax_office_no"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "invoice_styles", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "style_content"
  end

  create_table "invoices", force: true do |t|
    t.date     "date"
    t.time     "time"
    t.float    "tax_rate"
    t.integer  "customer_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "invoice_style_id"
  end

  add_index "invoices", ["invoice_style_id"], name: "index_invoices_on_invoice_style_id"

  create_table "line_items", force: true do |t|
    t.integer  "invoice_id"
    t.integer  "product_id"
    t.integer  "quantity"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "line_items", ["invoice_id"], name: "index_line_items_on_invoice_id"
  add_index "line_items", ["product_id"], name: "index_line_items_on_product_id"

  create_table "products", force: true do |t|
    t.text     "description"
    t.string   "unit"
    t.decimal  "unit_price",  precision: 8, scale: 2
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "provider"
    t.string   "uid"
    t.string   "name"
    t.string   "oauth_token"
    t.datetime "oauth_expires_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
