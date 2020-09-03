class Message < ApplicationRecord
  attr_accessor :partner_id
  validates :text, presence: {message: "が空欄です"}, length: {maximum: 150, message: "は150文字以内で入力してください"}

  belongs_to :to_user, class_name: "User"
  belongs_to :from_user, class_name: "User"
end
