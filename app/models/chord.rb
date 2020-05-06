class Chord < ApplicationRecord
  belongs_to :song
  belongs_to :user
  belongs_to :artist
  belongs_to :album
  has_many :likes, dependent: :destroy
end
