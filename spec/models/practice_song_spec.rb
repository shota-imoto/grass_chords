require 'rails_helper'
RSpec.describe PracticeSong, type: :model do
  describe "songレコードのpractice_songs_countのカウント" do
    let(:song) {FactoryBot.create(:song)}
    let(:song2) {FactoryBot.create(:song2)}
    describe "practice_songレコード登録時" do
      let(:practice_song) {FactoryBot.create(:practice_song, song_id: song.id)}
      subject{->{practice_song}}
      context "アソシエーション関係にある場合" do
        it {is_expected.to change{song.reload.practice_songs_count}.by(1)}
      end
      context "アソシエーション関係にない場合" do
        it {is_expected.to change{song2.reload.practice_songs_count}.by(0)}
      end
    end

    describe "practice_songレコード削除時" do
      let!(:practice_song) {FactoryBot.create(:practice_song, song_id: song.id)}
      subject{->{practice_song.destroy}}
      context "アソシエーション関係にある場合" do
        it {is_expected.to change{song.reload.practice_songs_count}.by(-1)}
      end
      context "アソシエーション関係にない場合" do
        it {is_expected.to change{song2.reload.practice_songs_count}.by(0)}
      end
    end
  end

  describe "practice_songレコード削除時の子レコードの一括削除" do
    let(:practice_song) {FactoryBot.create(:practice_song, :with_practices)}
    let(:practice_song2) {FactoryBot.create(:practice_song, :with_practices)}
    subject{->{practice_song.destroy}}
    context "アソシエーション関係にあるレコードは削除される" do
      it {is_expected.to change{practice_song.practices.length}.by(-10)}
    end
    context "アソシエーション関係にないレコードは削除されない" do
      it {is_expected.to change{practice_song2.practices.length}.by(0)}
    end
  end
end
