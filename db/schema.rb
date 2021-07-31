# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_07_31_145540) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "supported_lsoas", force: :cascade do |t|
    t.string "starts_with"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["starts_with"], name: "index_supported_lsoas_on_starts_with", unique: true
  end

  create_table "supported_postcodes", force: :cascade do |t|
    t.bigint "supported_lsoa_id"
    t.string "postcode"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["postcode"], name: "index_supported_postcodes_on_postcode"
    t.index ["supported_lsoa_id"], name: "index_supported_postcodes_on_supported_lsoa_id"
  end

end
