require 'rails_helper'

RSpec.describe Practice, type: :model do
  describe "chordレコードのpractices_countのカウント" do
    let(:chord) {FactoryBot.create(:chord)}
    let(:chord2) {FactoryBot.create(:chord2)}

    describe "practiceレコード登録時" do
      let(:practice) {FactoryBot.create(:practice, chord_id: chord.id)}
      subject{->{practice}}
      context "アソシエーション関係にある場合" do
        it {is_expected.to change{chord.reload.practices_count}.by(1)}
      end
      context "アソシエーション関係にない場合" do
        it {is_expected.to change{chord2.reload.practices_count}.by(0)}
      end
    end

    describe "practiceレコード削除時" do
      let!(:practice) {FactoryBot.create(:practice, chord_id: chord.id)}
      subject{->{practice.destroy}}
      context "アソシエーション関係にある場合" do
        it {is_expected.to change{chord.reload.practices_count}.by(-1)}
      end
      context "アソシエーション関係にない場合" do
        it {is_expected.to change{chord2.reload.practices_count}.by(0)}
      end
    end
  end
end
