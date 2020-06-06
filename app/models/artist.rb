class Artist < ApplicationRecord
  has_many :chords
  has_many :albums
end
