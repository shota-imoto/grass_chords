FactoryBot.define do
  factory :user do
    sequence(:id) {|n| n}
    sequence(:email) {|n| "bound_ride#{n}@bluegrass.com"}
    sequence(:name) {|n| "Jim Mills#{n}"}
    place {"North Carolina"}
    password {"scruggslove"}
    token {"token"}
    image {"image"}

    factory :ricky, class: User do
      name {"Ricky Skaggs"}
      place {"Nashville"}
      email {"little_maggie@bluegrass.com"}
      password {"billmonroelove"}
    end

    factory :bill, class: User do
      name {"Bill Monroe"}
      place {"Kentucky"}
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
