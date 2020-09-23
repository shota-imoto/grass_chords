require 'rails_helper'

RSpec.describe Users::RegistrationsController, type: :request do
  before do
    @test_user = FactoryBot.create(:user, id: 0, name: "Ralph Stanley")
  end
  describe "registrations#create" do
    before do
      response_mock = Net::HTTPOK.new(nil, 200, "OK")
      http_obj = double("Net::HTTP")
      recaptcha_mock = '{ "success": true, "challenge_ts": "2020-08-01T03:00:35Z", "hostname": "localhost", "score": 0.9, "action": "submit"}'
      allow(Net::HTTP).to receive(:get_response).and_return(response_mock)
      allow(response_mock).to receive(:body).and_return(recaptcha_mock)
    end
    it "userレコードを登録できる" do
      user_params = FactoryBot.attributes_for(:user)
      expect{
        post user_registration_path(user: user_params)
      }.to change(User, :count).by(1)
    end
  end
  describe "registrations#update" do
    before do
      @user = FactoryBot.create(:user, name: "Earl Scruggs")
      @other_user = FactoryBot.create(:user, name: "J.D. Crowe")
    end
    context "オーナー権を持つユーザーとして" do
      it "userレコードを更新できる" do
        login_as(@user)
        user_params = FactoryBot.attributes_for(:user, name: "Noam Pikelny", email: @user.email, current_password: @user.password)
        patch user_registration_path(user: user_params)
        expect(@user.reload.name).to eq "Noam Pikelny"
      end
    end
    context "オーナー権を持たないユーザーとして" do
      it "userレコードを更新できない" do
        login_as(@user)
        user_params = FactoryBot.attributes_for(:user, name: "Noam Pikelny", email: @other_user.email, current_password: @other_user.password)
        patch user_registration_path(user: user_params)
        expect(@other_user.reload.name).to eq "J.D. Crowe"
      end
    end
    context "テストユーザーとして" do
      it "userレコードを更新できない" do
        login_as(@test_user)
        user_params = FactoryBot.attributes_for(:user, name: "Noam Pikelny", email: @test_user.email, current_password: @test_user.password)
        patch user_registration_path(user: user_params)
        expect(@test_user.reload.name).to eq "Ralph Stanley"
      end
      it "rootにリダイレクトすること" do
        login_as(@test_user)
        user_params = FactoryBot.attributes_for(:user, name: "Noam Pikelny")
        patch user_registration_path(user: user_params)
        expect(response).to redirect_to root_path
      end
    end
  end
  describe "registrations#destroy" do
    before do
      @user = FactoryBot.create(:user, name: "Earl Scruggs")
      @other_user = FactoryBot.create(:user, name: "J.D. Crowe")
    end
    context "オーナー権を持つユーザーとして" do
      it "userレコードを削除できる" do
        login_as(@user)
        expect{
          delete user_registration_path(id: @user.id)
      }.to change(User, :count).by(-1)
      end
    end
    context "オーナー権を持たないユーザーとして" do
      it "userレコードを削除できない" do
        login_as(@user)
        expect{
          delete user_registration_path(id: @other_user.id)
        }.to change(User.where(id: @other_user.id), :count).by(0)
      end
    end
    context "テストユーザーとして" do
      it "userレコードを削除できない" do
        login_as(@test_user)
        expect{
          delete user_registration_path(id: @test_user.id)
        }.to change(User, :count).by(0)
      end
      it "rootにリダイレクトすること" do
        login_as(@test_user)
        delete user_registration_path(id: @test_user.id)
        expect(response).to redirect_to root_path
      end
    end
    context "ゲストとして" do
      it "userレコードを削除できない" do
        expect{
          delete user_registration_path(id: @user.id)
        }.to change(User, :count).by(0)
      end
    end
  end
end
