class Song < ApplicationRecord
  validates :title, uniqueness: {case_sensitive: false, message: ":%{value}は既に登録されています"}
  validates :title, presence: {message: "を入力してください"}
  validates :title, length: {in: 2..50, message: "は2~50文字に設定してください"}

  has_many :chords, dependent: :destroy
  has_many :practice_songs, dependent: :destroy
  belongs_to :user
end
