class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :chords
  has_many :likes, dependent: :destroy
  has_many :practices, dependent: :destroy
  has_many :instruments, through: :user_instruments
  has_many :user_instruments
  has_many :tuning_alls
  has_many :finger_alls
end
