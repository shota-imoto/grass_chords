FactoryBot.define do
  factory :practice_song do
    association :song
    association :user
  end
end
