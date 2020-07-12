FactoryBot.define do
  factory :chord do
    sequence(:id){|n| n}
    sequence(:version){|n| "standard#{n}"}
    key {"G"}
    association :song
    association :user

    factory :chord2, class: Chord do
      sequence(:version) {|n| "arrange#{n}"}
      key {"A"}
    end

    trait :with_chordunits do
      after(:create) {|chord| create_list(:chordunit, 48, chord: chord)}
    end

    trait :with_likes do
      after(:create) {|chord| create_list(:like, 10, chord: chord)}
    end

    trait :with_practices do
      after(:create) {|chord| create_list(:practice, 10, chord: chord)}
    end
  end
end
