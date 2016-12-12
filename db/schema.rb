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

ActiveRecord::Schema.define(:version => 20161212001741) do

  create_table "locations", :force => true do |t|
    t.string   "address"
    t.float    "latitude"
    t.float    "longitude"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
    t.string   "city"
    t.string   "state"
    t.string   "zipcode"
    t.float    "beds"
    t.float    "baths"
    t.float    "sqft"
    t.float    "list_price"
    t.float    "closing_price"
    t.float    "rent_price"
    t.float    "target_price"
    t.float    "maintenance"
    t.float    "taxes_annual"
    t.string   "listing_type"
    t.string   "zillow_page_link"
    t.string   "zillow_id"
    t.boolean  "commuter_hub"
    t.float    "price_per_sqft"
    t.float    "rent_per_sqft"
    t.float    "taxpercent"
    t.boolean  "closing_price_type"
    t.float    "parking_units"
    t.string   "agent"
    t.string   "last_sold_date"
    t.string   "last_sold_price"
    t.string   "sqft_type"
    t.boolean  "maintenance_type"
    t.boolean  "taxes_annual_type"
    t.boolean  "rent_price_type"
    t.float    "maint_percent"
    t.float    "caprate"
  end

  create_table "targets", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "address"
    t.float    "latitude"
    t.float    "longitude"
    t.float    "north"
    t.float    "south"
    t.float    "east"
    t.float    "west"
    t.float    "radius"
  end

end
