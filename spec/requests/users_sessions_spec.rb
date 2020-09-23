require 'rails_helper'

RSpec.describe Users::SessionsController, type: :request do
  describe "#test_create" do
    before do
      @user = FactoryBot.create(:user, id: 0, name: "Earl Scruggs")
    end
    it "302レスポンスを返すこと" do
      get users_test_sign_in_path
      expect(response).to have_http_status "302"
    end
    it "rootにリダイレクトすること" do
      get users_test_sign_in_path
      expect(response).to redirect_to root_path
    end
  end
  describe "#create" do
    before do
      @user = FactoryBot.create(:user)
    end
    context "recaptcha認証に成功した場合" do
      before do
        response_mock = Net::HTTPOK.new(nil, 200, "OK")
        http_obj = double("Net::HTTP")
        recaptcha_mock = '{ "success": true, "challenge_ts": "2020-08-01T03:00:35Z", "hostname": "localhost", "score": 0.9, "action": "submit"}'
        allow(Net::HTTP).to receive(:get_response).and_return(response_mock)
        allow(response_mock).to receive(:body).and_return(recaptcha_mock)
      end
      context "メールアドレスとパスワードが正しい場合" do
        it "302レスポンスを返すこと" do
          post user_session_path(user: {email: @user.email, password: @user.password, token: "token"})
          expect(response).to have_http_status "302"
        end
        it "フラッシュメッセージが表示されていること" do
          post user_session_path(user: {email: @user.email, password: @user.password, token: "token"})
          expect(flash[:notice]).to eq "ログインしました"
        end
        it "トップ画面にリダイレクトすること" do
          post user_session_path(user: {email: @user.email, password: @user.password, token: "token"})
          expect(response).to redirect_to root_path
        end
      end
      context "パスワードが誤っている場合" do
        it "200レスポンスを返すこと" do
          post user_session_path(user: {email: @user.email, password: "wrong password", token: "token"})
          have_http_status "200"
        end
        it "フラッシュメッセージが表示されていること" do
          post user_session_path(user: {email: @user.email, password: "wrong password", token: "token"})
          expect(flash[:notice]).to eq "メールアドレスもしくはパスワードに誤りがあります"
        end
      end
    end
    context "recaptcha認証に失敗した場合" do
      before do
        response_mock = Net::HTTPOK.new(nil, 200, "OK")
        http_obj = double("Net::HTTP")
        recaptcha_mock = '{"success": false, "error-codes": ["invalid-input-response"]}'
        allow(Net::HTTP).to receive(:get_response).and_return(response_mock)
        allow(response_mock).to receive(:body).and_return(recaptcha_mock)
      end
      it "200レスポンスを返すこと" do
        post user_session_path(user: {email: @user.email, password: @user.password, token: "token"})
        expect(response).to have_http_status "200"
      end
      it "フラッシュメッセージが表示されていること" do
        post user_session_path(user: {email: @user.email, password: @user.password, token: "token"})
        expect(flash[:notice]).to eq "Googleによって、アクセスが中止されました"
      end
    end
  end
end
