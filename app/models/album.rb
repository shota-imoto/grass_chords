class Album < ApplicationRecord
  has_many :chords
  belongs_to :artist
end
