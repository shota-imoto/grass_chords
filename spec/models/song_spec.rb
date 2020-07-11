require 'rails_helper'

RSpec.describe Song, type: :model do

  ###  リファクタリングが必要  ###
  ###        ここから       ###
  describe "song登録時のバリデーションチェック" do
    context "正常に登録されるとき" do
      it "title, jam, standard, beginner, vocal, instrumental, practice_songs_count, user_idがある場合は登録されること" do
        song = FactoryBot.build(:song)
        expect(song).to be_valid
      end
    end

    context "titleの値が登録されるとき" do
      it "titleが2文字の場合は登録されること" do
        song = FactoryBot.build(:song, title: "FS")
        expect(song).to be_valid
      end
      it "titleが50文字の場合は登録されること" do
        song = FactoryBot.build(:song, title: "KtxFcTVOxTDPzarwuLYCHcDmeGLDybPJCLexgDgcblqSaJDuOQ")
        expect(song).to be_valid
      end
    end

    context "titleの値が登録されないとき" do
      it "titleがない場合は登録できないこと" do
        song = FactoryBot.build(:song, title: nil)
        song.valid?
        expect(song.errors[:title]).to include("が空欄です")
      end
      it "titleが1文字の場合は登録されないこと" do
        song = FactoryBot.build(:song, title: "F")
        song.valid?
        expect(song.errors[:title]).to include("は2~50文字に設定してください")
      end
      it "titleが51文字の場合は登録されないこと" do
        song = FactoryBot.build(:song, title: "dbnnVRTXkNGSZSZamGVxGACzBtzQlKcXlDVyIgsqtkTuNAORtsQ")
        song.valid?
        expect(song.errors[:title]).to include("は2~50文字に設定してください")
      end
      it "すでに登録されているtitleの場合は登録されないこと" do
        FactoryBot.create(:song, title: "Foggy Mountain Special")
        song = FactoryBot.build(:song2, title: "Foggy Mountain Special")
        song.valid?
        expect(song.errors[:title]).to include(":Foggy Mountain Specialは既に登録されています")
      end
    end
  end
  ###  リファクタリングが必要  ###
  ###        ここまで       ###

  describe "songレコード削除時の子レコード一括削除" do
    let(:song) {FactoryBot.create(:song, :with_chords, :with_practice_songs)}
    let(:song2) {FactoryBot.create(:song2, :with_chords, :with_practice_songs)}
    subject{ ->{song.destroy}}

    context "アソシエーション関係のレコードは削除される" do
      it {is_expected.to change{song.chords.length}.by(-5)}
      it {is_expected.to change{song.practice_songs.length}.by(-5)}
    end

    context "アソシエーション関係ではないレコードは削除されない" do
      it {is_expected.to change{song2.chords.length}.by(0)}
      it {is_expected.to change{song2.practice_songs.length}.by(0)}
    end
  end
end
