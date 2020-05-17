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

ActiveRecord::Schema.define(version: 2020_05_14_135553) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "avatars", force: :cascade do |t|
    t.string "avatar"
  end

  create_table "friends", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "friend_id"
    t.string "favorite"
    t.index ["friend_id"], name: "index_friends_on_friend_id"
    t.index ["user_id"], name: "index_friends_on_user_id"
  end

  create_table "games", force: :cascade do |t|
    t.string "title"
    t.integer "serial"
    t.string "developer"
    t.string "platform"
    t.integer "score"
    t.datetime "release_date"
    t.string "cover"
    t.string "genre"
  end

  create_table "reviews", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "game_id"
    t.integer "score"
    t.text "comments"
    t.index ["game_id"], name: "index_reviews_on_game_id"
    t.index ["user_id"], name: "index_reviews_on_user_id"
  end

  create_table "stores", force: :cascade do |t|
    t.bigint "game_id"
    t.bigint "user_id"
    t.string "selling"
    t.string "condition"
    t.integer "price"
    t.index ["game_id"], name: "index_stores_on_game_id"
    t.index ["user_id"], name: "index_stores_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "username"
    t.string "password"
    t.string "avatar"
    t.string "background"
    t.string "location"
    t.string "social1"
    t.string "social2"
    t.string "social3"
    t.float "latitude"
    t.float "longitude"
    t.decimal "google_token"
    t.string "google_username"
    t.string "steam_username"
    t.bigint "steam_token"
  end

end
