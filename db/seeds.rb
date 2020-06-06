# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


Song.create(id:1, title: "Little Maggie", jam: 0, standard:1, beginner:0, user_id:1)
Chords.create(id: 1 song_id: 1, artist_id: 1, album_id:1, version: "traditional_version")
