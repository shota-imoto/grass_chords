# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


Song.create(id:1, title: "Little Maggie", jam: 0, standard:1, beginner:0, user_id:2)
Chord.create(id: 1, song_id: 1, artist_id: 1, album_id:1, version: "traditional_version")
User.create(id: 2, name: "dammy", place:"宇宙空間", email: "dammy@com", password: "11111111")
Artist.create(id:1, name: "No Artist")
Album.create(id:1, name: "No Album", artist_id: 1)
Chordunit.create(id:1, address:0, text:"G", leftbar: "", rightbar: "", beat: "", chord_id: 1)


