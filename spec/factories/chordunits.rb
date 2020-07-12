FactoryBot.define do
  factory :chordunit do
    sequence(:id){|n| n}
    sequence(:address){|n| n}
    text {"Gsm"}
    beat {"@"}
    leftbar {"{"}
    rightbar {"}"}
    association :chord
  end
end
