class User < ApplicationRecord
  # has_secure_password
  attr_accessor :token, :latest_message, :latest_message_date
  validates :name, presence: {message: "が空欄です"}, length: {in: 2..40, message: "は2~40文字に設定してください"}, uniqueness: {case_sensitive: false, message: "は既に登録されています"}
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
  has_many :received_messages, class_name: "Message", foreign_key: "to_user_id"
  has_many :sent_messages, class_name: "Message", foreign_key: "from_user_id"
  has_many :from_users, -> { distinct }, through: :received_messages
  has_many :to_users, -> { distinct }, through: :sent_messages

  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to :place

  def conversates_with(partner_id)
    self.received_messages.from_(partner_id).or(self.sent_messages.to_(partner_id))
  end

  def self.test_user_find
    self.find(0)
  end

  def update_without_current_password(params, *options)
    params.delete(:current_password)
    if params[:password].blank? && params[:password_confirmation].blank?

      params.delete(:password)
      params.delete(:password_confirmation)
    end

    result = update(params, *options)
    clean_up_passwords

    result
  end
end
