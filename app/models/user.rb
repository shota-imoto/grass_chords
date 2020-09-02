class User < ApplicationRecord
  # has_secure_password
  attr_accessor :token

  validates :name, presence: {message: "が空欄です"}, length: {in: 2..40, message: "は2~40文字に設定してください"}, uniqueness: {message: "は既に登録されています"}
  validates :email, uniqueness: {case_sensitive: false, message: "は既に登録されています"}, length: {in: 3..254, message: "は254文字以内のものを登録してください"}
  validates :place_id, presence: {message: "システムエラー：不正な値が入力されました"}
  validates :admin, exclusion: {in: [true], message: "システムエラー：不正な値が入力されました"}
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :songs
  has_many :chords
  has_many :likes, dependent: :destroy
  has_many :practices, dependent: :destroy
  has_many :practice_songs, dependent: :destroy
  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to :place

  def self.test_user_find
    self.find_by(id: "0")
  end



end
