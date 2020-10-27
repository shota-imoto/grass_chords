class Song < ApplicationRecord
  validates :title, uniqueness: {case_sensitive: false, message: ":%{value}は既に登録されています"}
  validates :title, presence: {message: "が空欄です"}
  validates :title, length: {in: 2..50, message: "は2~50文字に設定してください"}

  has_many :chords, dependent: :destroy
  has_many :practice_songs, dependent: :destroy
  belongs_to :user
  has_many :users, through: :practice_songs



  # 条件にチェックされているときのみand条件で絞り込み
  scope :where_jam, -> (is_jam){where(jam: is_jam) if (is_jam == "true")}
  scope :where_beginner, -> (is_beginner){where(beginner: is_beginner) if (is_beginner == "true")}
  scope :where_standard, -> (is_standard){where(standard: is_standard) if (is_standard == "true")}
  scope :where_vocal, -> (is_vocal){where(vocal: is_vocal) if (is_vocal == "true")}
  scope :where_instrumental, -> (is_instrumental){where(instrumental: is_instrumental) if (is_instrumental == "true")}
  scope :title_search, -> (keyword){where("title like ?", "%#{keyword}%")}

  def self.where_attributes(params)
    self.where_jam(params[:jam]).where_standard(params[:standard]).where_beginner(params[:beginner]).where_jam(params[:jam]).where_instrumental(params[:instrumental])
  end


  def self.search_keywords(keywords)
      keywords.each do |keyword| unless (keywords.nil?)
        title_search(keyword)
      end
  end

  def self.test(kind_of_sort)
      self.order("practice_songs_count desc, title asc")
  end
end

end
