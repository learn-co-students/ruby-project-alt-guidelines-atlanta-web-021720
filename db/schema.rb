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

ActiveRecord::Schema.define(version: 2020_03_03_000032) do

  create_table "generators", force: :cascade do |t|
    t.string "username"
    t.string "email"
  end

  create_table "ideas", force: :cascade do |t|
    t.string "title"
    t.text "post"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "generator_id"
  end

  create_table "implementers", force: :cascade do |t|
    t.string "username"
    t.string "email"
  end

  create_table "stashes", force: :cascade do |t|
    t.integer "idea_id"
    t.integer "implementer_id"
  end

end
