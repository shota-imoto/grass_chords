class Place < ActiveHash::Base
  include ActiveHash::Associations
  belongs_to :area
  has_many :users
  self.data = [
    {id: 0, name: "未設定", area_id: 0},
    {id: 1, name: '北海道', area_id: 1}, {id: 2, name: '青森県', area_id: 2}, {id: 3, name: '岩手県', area_id: 2},
    {id: 4, name: '宮城県', area_id: 2}, {id: 5, name: '秋田県', area_id: 2}, {id: 6, name: '山形県', area_id: 2},
    {id: 7, name: '福島県', area_id: 2}, {id: 8, name: '茨城県', area_id: 3}, {id: 9, name: '栃木県', area_id: 3},
    {id: 10, name: '群馬県', area_id: 3}, {id: 11, name: '埼玉県', area_id: 3}, {id: 12, name: '千葉県', area_id: 3},
    {id: 13, name: '東京都', area_id: 3}, {id: 14, name: '神奈川県', area_id: 3}, {id: 15, name: '新潟県', area_id: 4},
    {id: 16, name: '富山県', area_id: 4}, {id: 17, name: '石川県', area_id: 4}, {id: 18, name: '福井県', area_id: 4},
    {id: 19, name: '山梨県', area_id: 4}, {id: 20, name: '長野県', area_id: 4}, {id: 21, name: '岐阜県', area_id: 4},
    {id: 22, name: '静岡県', area_id: 4}, {id: 23, name: '愛知県', area_id: 4}, {id: 24, name: '三重県', area_id: 5},
    {id: 25, name: '滋賀県', area_id: 5}, {id: 26, name: '京都府', area_id: 5}, {id: 27, name: '大阪府', area_id: 5},
    {id: 28, name: '兵庫県', area_id: 5}, {id: 29, name: '奈良県', area_id: 5}, {id: 30, name: '和歌山県', area_id: 5},
    {id: 31, name: '鳥取県', area_id: 6}, {id: 32, name: '島根県', area_id: 6}, {id: 33, name: '岡山県', area_id: 6},
    {id: 34, name: '広島県', area_id: 6}, {id: 35, name: '山口県', area_id: 6}, {id: 36, name: '徳島県', area_id: 7},
    {id: 37, name: '香川県', area_id: 7}, {id: 38, name: '愛媛県', area_id: 7}, {id: 39, name: '高知県', area_id: 7},
    {id: 40, name: '福岡県', area_id: 8}, {id: 41, name: '佐賀県', area_id: 8}, {id: 42, name: '長崎県', area_id: 8},
    {id: 43, name: '熊本県', area_id: 8}, {id: 44, name: '大分県', area_id: 8}, {id: 45, name: '宮崎県', area_id: 8},
    {id: 46, name: '鹿児島県', area_id: 8}, {id: 47, name: '沖縄県', area_id: 8}, {id: 48, name: "アジア", area_id: 9},
    {id: 49, name: "オセアニア", area_id: 9}, {id: 50, name: "北アメリカ", area_id: 9}, {id: 51, name: "南アメリカ", area_id: 9},
    {id: 52, name: "ヨーロッパ", area_id: 9},{id: 53, name: "アフリカ", area_id: 9}
  ]
end
