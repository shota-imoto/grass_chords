FactoryBot.define do
  factory :message do
    sequence(:id) {|n| n}
    sequence(:text) {|n| "セッションしよう_#{n}"}
    association :to_user, factory: :user
    association :from_user, factory: :user
  end
end
