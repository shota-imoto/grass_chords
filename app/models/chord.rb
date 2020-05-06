class Chord < ApplicationRecord
  belongs_to :song
  belongs_to :artist
  belongs_to :album
end
