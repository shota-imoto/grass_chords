FactoryBot.define do
  factory :chordunit do
    sequence(:id){|n| n}
    sequence(:address){|n| n}
    part {"Intro, Solo"}
    repeat {"3."}
    indicator {"break"}
    text {"Gsm"}
    beat {"@"}
    leftbar {"{"}
    rightbar {"}"}
    association :chord

    factory :chordunit2, class: Chord do
      sequence(:id){|n| n}
      sequence(:address){|n| n}
      text {"Fb7"}
      beat {"#"}
      leftbar {""}
      rightbar {""}
    end
  end
end
