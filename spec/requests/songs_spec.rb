require 'rails_helper'

RSpec.describe SongsController, type: :request do
  describe "#show" do
    before do
      @song = FactoryBot.create(:song)
    end
    it "正常にレスポンスを返すこと" do
      get song_path(id: @song.id)
      expect(response).to be_successful
    end
    it "200レスポンスを返すこと" do
      get song_path(id: @song.id)
      expect(response).to have_http_status "200"
    end
  end
  describe "#create" do
    before do
      @user = FactoryBot.create(:user)
    end
    context "認可済みユーザーとして" do
      it "songレコードを登録できる" do
        login_as(@user)
        song_params = FactoryBot.attributes_for(:song)

        expect{
          post songs_path(song: song_params)
        }.to change(@user.songs, :count).by(1)
      end
    end
    context "ゲストとして" do
      it "302レスポンスを返すこと" do
        song_params = FactoryBot.attributes_for(:song)
        post songs_path(chord: song_params)
        expect(response).to have_http_status "302"
      end
      it "トップ画面にリダイレクトすること" do
        song_params = FactoryBot.attributes_for(:song)
        post songs_path(hord: song_params)
        expect(response).to redirect_to root_path
      end
    end
  end
  describe "update" do
    before do
      @user = FactoryBot.create(:user)
      @other_user = FactoryBot.create(:user)
    end
    context "オーナー権を持つユーザーとして" do
      before do
        @song = FactoryBot.create(:song, jam: false, user: @user)
      end
      it "songレコードを更新できる" do
        login_as(@user)
        song_params = FactoryBot.attributes_for(:song, jam: true)
        patch song_path(id: @song.id, song: song_params)
        expect(@song.reload.jam).to be_truthy
      end
    end
    context "オーナー権を持たないユーザーとして" do
      before do
        @song = FactoryBot.create(:song, jam: false, user: @other_user)
      end
      it "songレコードを更新できない" do
        login_as(@user)
        song_params = FactoryBot.attributes_for(:song, jam: true)
        patch song_path(id: @song.id, song: song_params)
        expect(@song.reload.jam).to be_falsey
      end
    end
    context "ゲストとして" do
      before do
        @song = FactoryBot.create(:song, jam: false, user: @other_user)
      end
      it "songレコードを更新できない" do
        song_params = FactoryBot.attributes_for(:song, jam: true)
        patch song_path(id: @song.id, song: song_params)
        expect(@song.reload.jam).to be_falsey
      end
    end
  end

  describe "destroy" do
    before do
      @user = FactoryBot.create(:user)
      @other_user = FactoryBot.create(:user)
    end
    context "オーナー権を持つユーザーとして" do
      before do
        @song = FactoryBot.create(:song, jam: false, user: @user)
      end
      it "songレコードを削除できる" do
        login_as(@user)
        expect{
          delete song_path(id: @song.id)
        }.to change(@user.songs, :count).by(-1)
      end
    end
    context "オーナー権を持たないユーザーとして" do
      before do
        @song = FactoryBot.create(:song, jam: false, user: @other_user)
      end
      it "songレコードを削除できない" do
        login_as(@user)
        expect{
          delete song_path(id: @song.id)
        }.to change(@user.songs, :count).by(0)
      end
    end
    context "ゲストとして" do
      before do
        @song = FactoryBot.create(:song, jam: false, user: @user)
      end
      it "songレコードを削除できない" do
        expect{
          delete song_path(id: @song.id)
        }.to change(@user.songs, :count).by(0)
      end
    end
  end
end
