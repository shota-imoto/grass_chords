class Practice < ApplicationRecord
  belongs_to :user
  belongs_to :chord, counter_cache: true
  belongs_to :practice_song

end
