FactoryBot.define do
  factory :practice do
    association :user
    association :chord
    association :practice_song
  end
end
