FactoryBot.define do
  factory :user do
    sequence(:id) {|n| n}
    sequence(:email) {|n| "bound_ride#{n}@bluegrass.com"}
    sequence(:name) {|n| "Jim Mills#{n}"}
    place_id {1}
    password {"scruggslove"}
    token {"token"}
    image {"image"}

    factory :ricky, class: User do
      name {"Ricky Skaggs"}
      place_id {2}
      email {"little_maggie@bluegrass.com"}
      password {"billmonroelove"}
    end

    factory :bill, class: User do
      name {"Bill Monroe"}
      place_id {3}
      email {"Roanoke@bluegrass.com"}
      password {"imfather"}
    end

    trait :with_likes do
      after(:create) {|user| create_list(:like, 10, user: user)}
    end

    trait :with_practices do
      after(:create) {|user| create_list(:practice, 10, user: user)}
    end

  end
end
