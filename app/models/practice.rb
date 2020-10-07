class Practice < ApplicationRecord
  belongs_to :user
  belongs_to :chord, counter_cache: true
  belongs_to :practice_song


  # def create_practice!(practice_song_params, practice_song)
  #   ActiveRecord::Base.transaction do
  #     binding.pry
  #     PracticeSong.create_practice_song!(practice_song_params)
  #     @practice = Practice.new(practice_params)
  #     @practice.save!
  #   end
  #   @chord = Chord.find(@practice.chord_id)
  # rescue => e
  #   logger.error "Exception Error: practice#create"
  #   logger.error e
  #   @error = "練習曲の登録に失敗しました。運営局に連絡してください"
  #   # User notices exception error by js.
  #   #TODO: make "logging error function" DRY.
  # end
end
