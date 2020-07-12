FactoryBot.define do
  factory :practice_song do
    association :song
    association :user

    trait :with_practices do
      after(:create) {|practice_song| create_list(:practice, 10, practice_song: practice_song)}
    end
  end
end
