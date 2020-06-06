class TuningAll < ApplicationRecord
  has_many :finger_alls
  has_many :tunings
  # accepts_nested_attributes_for :tunings
  belongs_to :instrument
  belongs_to :user

  attr_writer :tunings_attributes
  # def tuning
  #   [@tuning1, @tuning2]
  # end

  # def tunings_attributes=(string_num, note_num)
  #   @tunings_attributes = string_num, note_num
  # end
end
