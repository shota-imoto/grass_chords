FactoryBot.define do
  factory :chord do
    sequence(:id){|n| n}
    sequence(:version){|n| "standard#{n}"}
    key {"G"}
    association :song
    association :user
    # association :chordunit

    # trait :with_chordunits do
    #   after(:create) {|song| create_list(:chord, 48, chord: chord)}
    # end
  end
end
