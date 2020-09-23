require 'rails_helper'

RSpec.describe PracticesController, type: :request do

  # メモ: format: :json
  describe "#create" do
    context "オーナー権を持つユーザーとして"
    context "オーナー権を持たないユーザーとして"
    context "ゲストとして"
  end
  describe "#destroy" do
    context "オーナー権を持つユーザーとして"
    context "オーナー権を持たないユーザーとして"
    context "ゲストとして"
  end

  describe "#create" do
  before do
    @user = FactoryBot.create(:user)
    @other_user = FactoryBot.create(:user)
    @chord = FactoryBot.create(:chord)
  end
  context "オーナー権を持つユーザーとして" do
    it "js方式でレスポンスを返すこと" do
      login_as(@user)
      post practices_path(format: :json, chord_id: @chord.id, user_id: @user.id)
      expect(response.media_type).to eq "application/json"
    end
    it "practiceレコードを登録できる" do
      login_as(@user)
      expect{
        post practices_path(format: :json, chord_id: @chord.id, user_id: @user.id)
      }.to change(@user.practices, :count).by(1)
    end
  end
  context "オーナー権を持たないユーザーとして" do
    it "practiceレコードを登録できない" do
      login_as(@user)
      expect{
        post practices_path(format: :json, chord_id: @chord.id, user_id: @other_user.id)
      }.to change(@other_user.practices, :count).by(0)
    end
  end
  context "ゲストとして" do
    it "practiceレコードを登録できない" do
      expect{
        post practices_path(format: :json, chord_id: @chord.id, user_id: @user.id)
      }.to change(@user.practices, :count).by(0)
    end
    it "rootにリダイレクトすること" do
      post practices_path(format: :json, chord_id: @chord.id, user_id: @user.id)
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
      @practice = FactoryBot.create(:practice, user_id: @user.id)
    end
    it "js方式でレスポンスを返すこと" do
      login_as(@user)
      delete practice_path(format: :json, id: @practice.id)
      expect(response.media_type).to eq "application/json"
    end
    it "practiceレコードを削除できる" do
      login_as(@user)
      expect{
        delete practice_path(format: :json, id: @practice.id)
      }.to change(@user.practices, :count).by(-1)
    end
  end
  context "オーナー権を持たないユーザーとして" do
    before do
      @practice = FactoryBot.create(:practice, user_id: @other_user.id)
      FactoryBot.create(:practice, user_id: @user.id)
    end
    it "practiceレコードを削除できない" do
      login_as(@user)
      expect{
        delete practice_path(format: :json, id: @practice.id)
      }.to change(@other_user.practices, :count).by(0)
    end
  end
  context "ゲストとして" do
    before do
      @practice = FactoryBot.create(:practice, user_id: @user.id)
    end
    it "practiceレコード削除できない" do
      expect{
        delete practice_path(format: :json, id: @practice.id)
      }.to change(@other_user.practices, :count).by(0)
    end
    it "rootにリダイレクトすること" do
      delete practice_path(format: :json, id: @practice.id)
      expect(response).to redirect_to root_path
    end
  end
end
end
