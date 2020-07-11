require 'rails_helper'

RSpec.describe Song, type: :model do

  describe "全属性のバリデーション" do
    let(:song) {FactoryBot.build(:song)}
    subject{song}

    context "title, jam, standard, beginner, vocal, instrumental, practice_songs_count, user_idがある場合は登録されること" do
      it {is_expected.to be_valid}
    end
  end

  describe "titleのバリデーション" do
    let(:song) {FactoryBot.build(:song, title: title)}
    context "登録される" do
      subject {song}
      context "titleが2文字の場合" do
        let(:title) {"FS"}
        it {is_expected.to be_valid}
      end
      context "titleが50文字の場合" do
        let(:title) {"KtxFcTVOxTDPzarwuLYCHcDmeGLDybPJCLexgDgcblqSaJDuOQ"}
        it {is_expected.to be_valid}
      end
    end

    context "登録されない" do
      subject {song.errors[:title]}
      before do
        song.valid?
      end
      context "titleがない場合" do
        let(:title) {nil}
        it {is_expected.to include("が空欄です")}
      end
      context "titleが1文字の場合" do
        let(:title) {"F"}
        it {is_expected.to include("は2~50文字に設定してください")}
      end
      context "titleが51文字の場合" do
        let(:title) {"dbnnVRTXkNGSZSZamGVxGACzBtzQlKcXlDVyIgsqtkTuNAORtsQ"}
        it {is_expected.to include("は2~50文字に設定してください")}
      end
      context "既に登録されているtitleの場合" do
        let(:title) {"Foggy Mountain Special"}
        before do
          FactoryBot.create(:song, title: "Foggy Mountain Special")
          song.valid?
        end
        it {is_expected.to include(":Foggy Mountain Specialは既に登録されています")}
      end
    end
  end

  describe "songレコード削除時の子レコード一括削除" do
    let(:song) {FactoryBot.create(:song, :with_chords, :with_practice_songs)}
    let(:song2) {FactoryBot.create(:song2, :with_chords, :with_practice_songs)}
    subject{ ->{song.destroy}}

    context "アソシエーション関係にあるレコードは削除される" do
      it {is_expected.to change{song.chords.length}.by(-5)}
      it {is_expected.to change{song.practice_songs.length}.by(-5)}
    end

    context "アソシエーション関係ではないレコードは削除されない" do
      it {is_expected.to change{song2.chords.length}.by(0)}
      it {is_expected.to change{song2.practice_songs.length}.by(0)}
    end
  end
end
