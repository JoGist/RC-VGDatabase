class User < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
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
    t.numeric "google_token"
    t.string "google_username"
    t.string "steam_username"
    t.bigint "steam_token"
  end
  end
end
