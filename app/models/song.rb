class Song < ApplicationRecord
  validates :title, uniqueness: {case_sensitive: false, message: "%{value}は既に登録されています"}
  validates :title, presence: {message: "タイトルを入力してください"}

  has_many :chords, dependent: :destroy
  has_many :scores, dependent: :destroy
  has_many :practices, dependent: :destroy
  belongs_to :user

end
