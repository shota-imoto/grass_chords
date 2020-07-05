# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


Song.create(id: 1, title: "Little Maggie", jam: 0, standard: 1, beginner: 0, vocal: 1, instrumental: 0, practice_songs_count: 0, user_id: 1)
User.create(id: 0, name: "テストユーザー", place: "火星", email: "test@exam.com", password: "19920818", admin: "false")


