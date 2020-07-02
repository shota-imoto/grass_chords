class PracticeSong < ApplicationRecord
  belongs_to :song, counter_cache: true
  belongs_to :user
  has_many :practices, dependent: :destroy



end
