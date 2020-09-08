# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_09_06_075344) do

  create_table "chords", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "song_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.string "version"
    t.integer "likes_count", default: 0
    t.integer "practices_count", default: 0
    t.string "key", default: "G", null: false
    t.index ["song_id"], name: "index_chords_on_song_id"
    t.index ["user_id"], name: "index_chords_on_user_id"
  end

  create_table "chordunits", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "address", null: false
    t.text "text"
    t.string "leftbar"
    t.string "rightbar"
    t.string "beat"
    t.bigint "chord_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "indicator", default: ""
    t.string "repeat", default: ""
    t.string "part", default: ""
    t.index ["chord_id"], name: "index_chordunits_on_chord_id"
  end

  create_table "likes", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "chord_id"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["chord_id"], name: "index_likes_on_chord_id"
    t.index ["user_id"], name: "index_likes_on_user_id"
  end

  create_table "messages", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "text", null: false
    t.bigint "to_user_id"
    t.bigint "from_user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["from_user_id"], name: "index_messages_on_from_user_id"
    t.index ["to_user_id"], name: "index_messages_on_to_user_id"
  end

  create_table "practice_songs", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "song_id"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["song_id"], name: "index_practice_songs_on_song_id"
    t.index ["user_id"], name: "index_practice_songs_on_user_id"
  end

  create_table "practices", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "chord_id"
    t.bigint "practice_song_id"
    t.index ["chord_id"], name: "index_practices_on_chord_id"
    t.index ["practice_song_id"], name: "index_practices_on_practice_song_id"
    t.index ["user_id"], name: "index_practices_on_user_id"
  end

  create_table "songs", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "title", null: false
    t.boolean "jam", null: false
    t.boolean "standard", null: false
    t.boolean "beginner", null: false
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "vocal", null: false
    t.boolean "instrumental", null: false
    t.integer "practice_songs_count", default: 0
    t.index ["user_id"], name: "index_songs_on_user_id"
  end

  create_table "users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "admin", default: false
    t.string "image"
    t.integer "place_id", default: 0, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "chords", "songs"
  add_foreign_key "chords", "users"
  add_foreign_key "chordunits", "chords"
  add_foreign_key "likes", "chords"
  add_foreign_key "likes", "users"
  add_foreign_key "messages", "users", column: "from_user_id"
  add_foreign_key "messages", "users", column: "to_user_id"
  add_foreign_key "practice_songs", "songs"
  add_foreign_key "practice_songs", "users"
  add_foreign_key "practices", "chords"
  add_foreign_key "practices", "practice_songs"
  add_foreign_key "practices", "users"
  add_foreign_key "songs", "users"
end
