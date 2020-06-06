json.extract! song, :id, :title, :jam, :standard, :beginner, :user_id, :created_at, :updated_at
json.url song_url(song, format: :json)
