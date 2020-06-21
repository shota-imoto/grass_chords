class Chord < ApplicationRecord

  belongs_to :song
  belongs_to :user
  has_many :chordunits, dependent: :destroy
  accepts_nested_attributes_for :chordunits
  has_many :likes, dependent: :destroy
  has_many :practices, dependent: :destroy
end
