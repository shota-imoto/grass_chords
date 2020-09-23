class Message < ApplicationRecord
  attr_accessor :partner_id
  validates :text, presence: {message: "が空欄です"}, length: {maximum: 150, message: "は150文字以内で入力してください"}

  belongs_to :to_user, class_name: "User"
  belongs_to :from_user, class_name: "User"

  scope :from_, ->(user_id){where(from_user_id: user_id)}
  scope :to_, ->(user_id){where(to_user_id: user_id)}

end
