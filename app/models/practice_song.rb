class PracticeSong < ApplicationRecord
  belongs_to :song, counter_cache: true
  belongs_to :user
  has_many :practices, dependent: :destroy

  def self.create_practice_song!(practice_song_params)
    self.create!(practice_song_params) unless self.where(practice_song_params).exists?
  end

  def self.destroy_practice_song!(practice_song_id)
    self.find(practice_song_id).destroy! unless Practice.where(practice_song_id: practice_song_id).exists?
  end
end
