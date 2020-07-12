class Chord < ApplicationRecord
  validates :version, length: {maximum: 50, message: "は50文字以内で設定してください"}
  validates :key, presence: {message: "が空欄です：システムエラー：管理者に連絡してください"}, length: {maximum: 3, message: "は3文字以内で設定してください：システムエラー：管理者に連絡してください"}

  belongs_to :song
  belongs_to :user
  has_many :chordunits, dependent: :destroy
  accepts_nested_attributes_for :chordunits
  has_many :likes, dependent: :destroy
  has_many :practices, dependent: :destroy


end
