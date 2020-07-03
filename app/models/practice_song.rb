class PracticeSong < ApplicationRecord
  belongs_to :song, counter_cache: true
  belongs_to :user
  has_many :practices, dependent: :destroy


  def self.common_practice_songs(practice_song)
    self.find_by(practice_song_params)
end
