class Chord < ApplicationRecord
  validates :version, length: {maximum: 50, message: "は50文字以内で設定してください"}
  validates :key, length: {in: 1..3, message: "は20文字以内で設定してください：システムエラー：管理者に連絡してください"}
  validates_associated :chordunits

  belongs_to :song
  belongs_to :user
  has_many :chordunits, dependent: :destroy
  accepts_nested_attributes_for :chordunits
  has_many :likes, dependent: :destroy
  has_many :practices, dependent: :destroy
end
