class Instrument < ApplicationRecord
  has_many :finger_alls, dependent: :destroy
  has_many :tuning_alls, dependent: :destroy
  has_many :users, through: :user_instruments
  has_many :user_instrumentsend
end