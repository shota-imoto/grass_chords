class Chordunit < ApplicationRecord
  validates :address, presence: {message: "がコードノートデータに含まれておりません：フォームエラー：管理者に連絡してください"}
  validates :text, length: {maximum: 20, message: "の文字数は20文字以内にしてください"}
  validates :beat, :leftbar, :rightbar, length: {maximum: 1, message: "は2文字以上に設定しないでください：システムエラー：管理者に連絡してください"}
  belongs_to :chord
end
