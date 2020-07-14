require 'rails_helper'

RSpec.describe LikesController, type: :controller do
  describe "#create" do
    before do
      @user = FactoryBot.create(:user)
      @other_user = FactoryBot.create(:user)
      @chord = FactoryBot.create(:chord)
    end
    context "オーナー権を持つユーザーとして" do
      it "js方式でレスポンスを返すこと" do
        sign_in @user
        post :create, format: :js, params: {chord_id: @chord.id, user_id: @user.id}
        expect(response.content_type).to eq "text/javascript"
      end
      it "likeレコードを登録できる" do
        sign_in @user
        expect{
          post :create, format: :js, params: {chord_id: @chord.id, user_id: @user.id}
        }.to change(@user.likes, :count).by(1)
      end
    end
    context "オーナー権を持たないユーザーとして" do
      it "likeレコードを登録できない" do
        sign_in @user
        expect{
          post :create, format: :js, params: {chord_id: @chord.id, user_id: @other_user.id}
        }.to change(@other_user.likes, :count).by(0)
      end
    end
    context "ゲストとして" do
      it "likeレコードを登録できない" do
        expect{
          post :create, format: :js, params: {chord_id: @chord.id, user_id: @user.id}
        }.to change(@user.likes, :count).by(0)
      end
      it "rootにリダイレクトすること" do
        post :create, format: :js, params: {chord_id: @chord.id, user_id: @user.id}
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
        sign_in @user
        delete :destroy, format: :js, params: {id: @like.id}
        expect(response.content_type).to eq "text/javascript"
      end
      it "likeレコードを削除できる" do
        sign_in @user
        expect{
          delete :destroy, format: :js, params: {id: @like.id}
        }.to change(@user.likes, :count).by(-1)
      end
    end
    context "オーナー権を持たないユーザーとして" do
      before do
        @like = FactoryBot.create(:like, user_id: @other_user.id)
        FactoryBot.create(:like, user_id: @user.id)
      end
      it "likeレコードを削除できない" do
        sign_in @user
        expect{
          delete :destroy, format: :js, params: {id: @like.id}
        }.to change(@other_user.likes, :count).by(0)
      end
    end
    context "ゲストとして" do
      before do
        @like = FactoryBot.create(:like, user_id: @user.id)
      end
      it "likeレコード削除できない" do
        expect{
          delete :destroy, format: :js, params: {id: @like.id}
        }.to change(@other_user.likes, :count).by(0)
      end
      it "rootにリダイレクトすること" do
        delete :destroy, format: :js, params: {id: @like.id}
        expect(response).to redirect_to root_path
      end
    end
  end
end
