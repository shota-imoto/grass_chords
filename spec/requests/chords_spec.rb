require 'rails_helper'

RSpec.describe ChordsController, type: :request do
  describe "#index" do
    it "正常にレスポンスを返すこと" do
      get root_path
      expect(response).to be_successful
    end

    it "200レスポンスを返すこと" do
      get root_path
      expect(response).to have_http_status "200"
    end
  end

  describe "#show" do
    before do
      @chord = FactoryBot.create(:chord)
    end

    it "正常にレスポンスを返すこと" do
      get chord_path(@chord.id)
      expect(response).to be_successful
    end
  end

  describe "#create" do
    before do
      @user = FactoryBot.create(:user)
      @song = FactoryBot.create(:song)
    end
    context "認可済みユーザーとして" do
      it "chordレコードを登録できる" do
        login_as(@user)
        chord_params = FactoryBot.attributes_for(:chord, user_id: @user.id, song_id: @song.id)

        expect{
          post chords_path(chord: chord_params)
        }.to change(@user.chords, :count).by(1)
      end
    end

    context "ゲストとして" do
      it "302レスポンスを返すこと" do
        chord_params = FactoryBot.attributes_for(:chord, user_id: @user.id, song_id: @song.id)
        post chords_path(chord: chord_params)
        expect(response).to have_http_status "302"
      end

      it "トップ画面にリダイレクトすること" do
        chord_params = FactoryBot.attributes_for(:chord, user_id: @user.id, song_id: @song.id)
        post chords_path(chord: chord_params)
        expect(response).to redirect_to "/"
      end
    end
  end

  describe "#update" do
    before do
      @user = FactoryBot.create(:user)
      @other_user = FactoryBot.create(:user)
    end
    context "オーナー権を持つユーザーとして" do
      before do
        @chord = FactoryBot.create(:chord, version: "old", user: @user)
      end
      it "chordレコードを更新できる" do
        login_as(@user)
        chord_params = FactoryBot.attributes_for(:chord, version: "new")
        patch chord_path(id: @chord.id, chord: chord_params)
        expect(@chord.reload.version).to eq "new"
      end
    end
    context "オーナー権のないユーザーとして" do
      before do
        @chord = FactoryBot.create(:chord, version: "old", user: @other_user)
      end
      it "chordレコードを更新できないこと" do
        login_as(@user)
        chord_params = FactoryBot.attributes_for(:chord, version: "new")
        patch chord_path(id: @chord.id, chord: chord_params)
        expect(@chord.reload.version).to eq "old"
      end

      it "rootにリダイレクトすること" do
        login_as(@user)
        chord_params = FactoryBot.attributes_for(:chord, version: "new")
        patch chord_path(id: @chord.id, chord: chord_params)
        expect(response).to redirect_to root_path
      end
    end
    context "ゲストとして" do
      before do
        @chord = FactoryBot.create(:chord, version: "old")
      end
      it "chordレコードを更新できない" do
        chord_params = FactoryBot.attributes_for(:chord, version: "new")
        patch chord_path(id: @chord.id, chord: chord_params)
        expect(@chord.reload.version).to eq "old"
      end
      it "rootにリダイレクトすること" do
        chord_params = FactoryBot.attributes_for(:chord, version: "new")
        patch chord_path(id: @chord.id, chord: chord_params)
        expect(response).to redirect_to root_path
      end
    end
  end

  describe "#destory" do
    before do
      @user = FactoryBot.create(:user)
      @other_user = FactoryBot.create(:user)
    end
    context "オーナー権を持つユーザーとして" do
      before do
        @chord = FactoryBot.create(:chord, user: @user)
      end
      it "chordレコードを削除できる" do
        login_as(@user)
        expect{
          delete chord_path(id: @chord.id)
        }.to change(@user.chords, :count).by(-1)
      end
    end
    context "オーナー権を持たないユーザーとして" do
      before do
        @chord = FactoryBot.create(:chord, user: @other_user)
      end
      it "chordレコードを削除できない" do
        login_as(@user)
        expect{
          delete chord_path(id: @chord.id)
        }.to_not change(@user.chords, :count)
      end
      it "rootにリダイレクトすること" do
        login_as(@user)
        delete chord_path(id: @chord.id)
        expect(response).to redirect_to root_path
      end
    end
    context "ゲストとして" do
      before do
        @chord = FactoryBot.create(:chord, user: @user)
      end
      it "chordレコードを削除できない" do
        expect{
          delete chord_path(id: @chord.id)
        }.to_not change(@user.chords, :count)
      end
      it "rootにリダイレクトすること" do
        delete chord_path(id: @chord.id)
        expect(response).to redirect_to root_path
      end
    end
  end
end
