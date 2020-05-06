class FingerAll < ApplicationRecord
  belongs_to :instrument
  belongs_to :tuning_all
  has_many :fingers
  belongs_to :user
end
