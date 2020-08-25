require 'rails_helper'

RSpec.describe Chord, type: :model do
  describe "versionのバリデーション" do
    let(:chord) {FactoryBot.build(:chord, version: version)}
    context "登録される" do
      subject {chord}
      context "versionの文字数が50文字の場合" do
        let(:version) {"ZeqzRTsydTLxXzpofXrOMboOnpSQkrpaYqXGlulyBObfHIxyUx"}
        it {is_expected.to be_valid}
      end
    end
    context "登録されない" do
      subject {chord.errors[:version]}
      before do
        chord.valid?
      end
      context "versionの文字数が51文字の場合" do
        let(:version) {"WsUfazsCypzthgVlnSGNaNvcoTuuJYoSrADgjcrVpCtqzQfCaxp"}
        it {is_expected.to include("は50文字以内で設定してください")}
      end
    end
  end

  describe "keyのバリデーション" do
    let(:chord) {FactoryBot.build(:chord, key: key)}
    context "登録される" do
      subject {chord}
      context "keyの文字数が3文字の場合" do
        let(:key) {"Gsm"}
        it {is_expected.to be_valid}
      end
    end
    context "登録されない" do
      subject {chord.errors[:key]}
      before do
        chord.valid?
      end
      context "keyがない場合" do
        let(:key) {nil}
        it {is_expected.to include("が空欄です：システムエラー：管理者に連絡してください")}
      end
      context "keyの文字数が4文字の場合" do
        let(:key) {"GsmA"}
        it {is_expected.to include("は3文字以内で設定してください：システムエラー：管理者に連絡してください")}
      end
    end
  end

  describe "chordレコード削除時に子レコードの一括削除" do
    let(:chord) {FactoryBot.create(:chord, :with_chordunits, :with_likes, :with_practices)}
    let(:chord2) {FactoryBot.create(:chord2, :with_chordunits, :with_likes, :with_practices)}
    subject{->{chord.destroy}}
    context "アソシエーション関係にあるレコードは削除される" do
      it {is_expected.to change{chord.chordunits.length}.by(-$chordunit_num)}
      it {is_expected.to change{chord.likes.length}.by(-10)}
      it {is_expected.to change{chord.practices.length}.by(-10)}
    end
    context "アソシエーション関係にないレコードは削除されない" do
      it {is_expected.to change{chord2.chordunits.length}.by(0)}
      it {is_expected.to change{chord2.likes.length}.by(0)}
      it {is_expected.to change{chord2.practices.length}.by(0)}
    end
  end
end
