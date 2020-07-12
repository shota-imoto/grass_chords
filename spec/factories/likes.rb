FactoryBot.define do
  factory :like do
    association :user
    association :chord
  end
end
