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

ActiveRecord::Schema.define(version: 2020_05_26_092824) do

  create_table "albums", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name", null: false
    t.bigint "artist_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["artist_id"], name: "index_albums_on_artist_id"
  end

  create_table "artists", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "chords", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "song_id"
    t.bigint "artist_id"
    t.bigint "album_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.string "version"
    t.integer "likes_count", default: 0
    t.index ["album_id"], name: "index_chords_on_album_id"
    t.index ["artist_id"], name: "index_chords_on_artist_id"
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
    t.index ["chord_id"], name: "index_chordunits_on_chord_id"
  end

  create_table "finger_alls", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name", null: false
    t.bigint "instrument_id"
    t.bigint "tuning_all_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["instrument_id"], name: "index_finger_alls_on_instrument_id"
    t.index ["tuning_all_id"], name: "index_finger_alls_on_tuning_all_id"
  end

  create_table "fingers", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "string_num", null: false
    t.integer "fret_num", null: false
    t.bigint "finger_all_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["finger_all_id"], name: "index_fingers_on_finger_all_id"
  end

  create_table "instruments", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name", null: false
    t.integer "total_string", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "keys", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name", null: false
    t.boolean "instrumental", null: false
    t.boolean "male", null: false
    t.boolean "female", null: false
    t.bigint "song_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["song_id"], name: "index_keys_on_song_id"
  end

  create_table "likes", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "chord_id"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["chord_id"], name: "index_likes_on_chord_id"
    t.index ["user_id"], name: "index_likes_on_user_id"
  end

  create_table "practices", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "song_id"
    t.bigint "user_id"
    t.integer "practice_key"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["song_id"], name: "index_practices_on_song_id"
    t.index ["user_id"], name: "index_practices_on_user_id"
  end

  create_table "scores", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.text "image", null: false
    t.integer "chord_num", null: false
    t.bigint "song_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["song_id"], name: "index_scores_on_song_id"
  end

  create_table "songs", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "title", null: false
    t.boolean "jam", null: false
    t.boolean "standard", null: false
    t.boolean "beginner", null: false
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_songs_on_user_id"
  end

  create_table "tuning_alls", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name", null: false
    t.bigint "instrument_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.index ["instrument_id"], name: "index_tuning_alls_on_instrument_id"
    t.index ["user_id"], name: "index_tuning_alls_on_user_id"
  end

  create_table "tunings", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "string_num", null: false
    t.string "note_name", null: false
    t.bigint "tuning_all_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tuning_all_id"], name: "index_tunings_on_tuning_all_id"
  end

  create_table "user_instruments", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "instrument_id"
    t.integer "default_inst"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["instrument_id"], name: "index_user_instruments_on_instrument_id"
    t.index ["user_id"], name: "index_user_instruments_on_user_id"
  end

  create_table "users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name", null: false
    t.string "place"
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "albums", "artists"
  add_foreign_key "chords", "albums"
  add_foreign_key "chords", "artists"
  add_foreign_key "chords", "songs"
  add_foreign_key "chords", "users"
  add_foreign_key "chordunits", "chords"
  add_foreign_key "finger_alls", "instruments"
  add_foreign_key "finger_alls", "tuning_alls"
  add_foreign_key "fingers", "finger_alls"
  add_foreign_key "keys", "songs"
  add_foreign_key "likes", "chords"
  add_foreign_key "likes", "users"
  add_foreign_key "practices", "songs"
  add_foreign_key "practices", "users"
  add_foreign_key "scores", "songs"
  add_foreign_key "songs", "users"
  add_foreign_key "tuning_alls", "instruments"
  add_foreign_key "tuning_alls", "users"
  add_foreign_key "tunings", "tuning_alls"
  add_foreign_key "user_instruments", "instruments"
  add_foreign_key "user_instruments", "users"
end
