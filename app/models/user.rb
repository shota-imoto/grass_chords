class User < ApplicationRecord
  validates :name, presence: {message: "が空欄です"}
  validates :name, length: {in: 2..40, message: "は2~40文字に設定してください"}
  validates :email, uniqueness: {case_sensitive: false, message: "は既に登録されています"}
  validates :email, length: {in: 3..254, message: "は254文字以内のものを登録してください"}
  validates :place, length: {maximum: 50, message: "は50文字以内に設定してください"}
  validates :admin, exclusion: {in: [true]}
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :songs
  has_many :chords
  has_many :likes, dependent: :destroy
  has_many :practices, dependent: :destroy
  has_many :practice_songs, dependent: :destroy

  def self.test_user_find
    self.find_by(id: "0")
  end

end
