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

ActiveRecord::Schema.define(version: 2020_03_05_234926) do

  create_table "actors", force: :cascade do |t|
    t.string "name"
  end

  create_table "genres", force: :cascade do |t|
    t.string "name"
  end

  create_table "movie_actors", force: :cascade do |t|
    t.integer "movie_id"
    t.integer "actor_id"
  end

  create_table "movie_genres", force: :cascade do |t|
    t.integer "movie_id"
    t.integer "genre_id"
  end

  create_table "movies", force: :cascade do |t|
    t.string "name"
    t.integer "price"
  end

  create_table "rents", force: :cascade do |t|
    t.datetime "start_date"
    t.datetime "end_date"
    t.boolean "free_event"
    t.integer "user_id"
    t.integer "movie_id"
    t.boolean "return"
  end

  create_table "users", force: :cascade do |t|
    t.string "login_id", null: false
    t.string "password"
    t.string "name"
    t.integer "point"
    t.index ["login_id"], name: "index_users_on_login_id", unique: true
  end

end
