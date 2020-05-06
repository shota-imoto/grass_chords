class Song < ApplicationRecord
  has_many :chords, dependent: :destroy
  has_many :practices, dependent: :destroy
  has_many :keys, dependent: :destroy
  has_many :scores, dependent: :destroy
  belongs_to :user
end
