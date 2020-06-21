class Song < ApplicationRecord
  validates :title, presence: true, uniqueness: {case_sensitive: false}

  has_many :chords, dependent: :destroy
  has_many :keys, dependent: :destroy
  has_many :scores, dependent: :destroy
  belongs_to :user
end
