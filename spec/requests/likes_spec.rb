require 'rails_helper'

RSpec.describe LikesController, type: :request do
  describe "#create" do
    before do
      @user = FactoryBot.create(:user)
      @other_user = FactoryBot.create(:user)
      @chord = FactoryBot.create(:chord)
    end
    context "オーナー権を持つユーザーとして" do
      it "js方式でレスポンスを返すこと" do
        login_as(@user)
        post likes_path(format: :json, chord_id: @chord.id, user_id: @user.id)
        expect(response.media_type).to eq "application/json"
      end
      it "likeレコードを登録できる" do
        login_as(@user)
        expect{
          post likes_path(format: :json, chord_id: @chord.id, user_id: @user.id)
        }.to change(@user.likes, :count).by(1)
      end
    end
    context "オーナー権を持たないユーザーとして" do
      it "likeレコードを登録できない" do
        login_as(@user)
        expect{
          post likes_path(format: :json, chord_id: @chord.id, user_id: @other_user.id)
        }.to change(@other_user.likes, :count).by(0)
      end
    end
    context "ゲストとして" do
      it "likeレコードを登録できない" do
        expect{
          post likes_path(format: :json, chord_id: @chord.id, user_id: @user.id)
        }.to change(@user.likes, :count).by(0)
      end
      it "rootにリダイレクトすること" do
        post likes_path(format: :json, chord_id: @chord.id, user_id: @user.id)
        expect(response).to redirect_to root_path
      end
    end
  end
  describe "#destroy" do
    before do
      @user = FactoryBot.create(:user)
      @other_user = FactoryBot.create(:user)
      @chord = FactoryBot.create(:chord)
    end
    context "オーナー権を持つユーザーとして" do
      before do
        @like = FactoryBot.create(:like, user_id: @user.id)
      end
      it "js方式でレスポンスを返すこと" do
        login_as(@user)
        delete like_path(format: :json, id: @like.id)
        expect(response.media_type).to eq "application/json"
      end
      it "likeレコードを削除できる" do
        login_as(@user)
        expect{
          delete like_path(format: :json, id: @like.id)
        }.to change(@user.likes, :count).by(-1)
      end
    end
    context "オーナー権を持たないユーザーとして" do
      before do
        @like = FactoryBot.create(:like, user_id: @other_user.id)
        FactoryBot.create(:like, user_id: @user.id)
      end
      it "likeレコードを削除できない" do
        login_as(@user)
        expect{
          delete like_path(format: :json, id: @like.id)
        }.to change(@other_user.likes, :count).by(0)
      end
    end
    context "ゲストとして" do
      before do
        @like = FactoryBot.create(:like, user_id: @user.id)
      end
      it "likeレコード削除できない" do
        expect{
          delete like_path(format: :json, id: @like.id)
        }.to change(@other_user.likes, :count).by(0)
      end
      it "rootにリダイレクトすること" do
        delete like_path(format: :json, id: @like.id)
        expect(response).to redirect_to root_path
      end
    end
  end
end
