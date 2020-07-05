class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :chords
  has_many :likes, dependent: :destroy
  has_many :practices, dependent: :destroy
  has_many :practices, dependent: :destroy

  def self.test_user_find
    self.find_by(name: "テストユーザー")
  end

end
