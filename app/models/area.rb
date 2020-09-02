class Area < ActiveHash::Base
  include ActiveHash::Associations
  has_many :places
  self.data = [
    {id: 0, name: "未設定"},
    {id: 1, name: "北海道"},
    {id: 2, name: "東北"},
    {id: 3, name: "関東"},
    {id: 4, name: "中部"},
    {id: 5, name: "近畿"},
    {id: 6, name: "中国"},
    {id: 7, name: "四国"},
    {id: 8, name: "九州・沖縄"},
    {id: 9, name: "グローバル"},
  ]
end
