class TuningAll < ApplicationRecord
  has_many :finger_alls
  has_many :tunings
  belongs_to :instrument
  belongs_to :user
end
