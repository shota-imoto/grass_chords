require 'rails_helper'

RSpec.describe Like, type: :model do
  describe "chordレコードのlikes_countのカウント" do
    let(:chord) {FactoryBot.create(:chord)}
    let(:chord2) {FactoryBot.create(:chord2)}
    describe "likeレコード登録時" do
      let(:like) {FactoryBot.create(:like, chord_id: chord.id)}
      subject{->{like}}
      context "アソシエーション関係にある場合" do
        it {is_expected.to change{chord.reload.likes_count}.by(1)}
      end
      context "アソシエーション関係にない場合" do
        it {is_expected.to change{chord2.reload.likes_count}.by(0)}
      end
    end

    describe "likeレコード削除時" do
      let!(:like) {FactoryBot.create(:like, chord_id: chord.id)}
      subject{->{like.destroy}}
      context "アソシエーション関係にある場合" do
        it {is_expected.to change{chord.reload.likes_count}.by(-1)}
      end
      context "アソシエーション関係にない場合" do
        it {is_expected.to change{chord2.reload.likes_count}.by(0)}
      end
    end
  end
end
