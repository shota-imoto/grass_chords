require 'rails_helper'

RSpec.describe Users::SessionsController, type: :controller do
  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end
  describe "#test_create" do
    before do
      @user = FactoryBot.create(:user, id: 0, name: "Earl Scruggs")
      allow(controller)
        .to receive(:current_user)
        .and_return(@user)
    end
    it "302レスポンスを返すこと" do
      get :test_create
      expect(response).to have_http_status "302"
    end
    it "rootにリダイレクトすること" do
      get :test_create
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
          post :create, params: {user: {email: @user.email, password: @user.password, token: "token"}}
          expect(response).to have_http_status "302"
        end
        it "フラッシュメッセージが表示されていること" do
          post :create, params: {user: {email: @user.email, password: @user.password, token: "token"}}
          expect(flash[:notice]).to eq "ログインしました"
        end
        it "トップ画面にリダイレクトすること" do
          post :create, params: {user: {email: @user.email, password: @user.password, token: "token"}}
          expect(response).to redirect_to root_path
        end
      end
      context "パスワードが誤っている場合" do
        it "sessions#newにrenderすること" do
          post :create, params: {user: {email: @user.email, password: "wrong password", token: "token"}}
          expect(response).to render_template(:new)
        end
        it "フラッシュメッセージが表示されていること" do
          post :create, params: {user: {email: @user.email, password: "wrong password", token: "token"}}
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
      it "sessions#newにrenderすること" do
        post :create, params: {user: {email: @user.email, password: @user.password, token: "token"}}
        expect(response).to render_template(:new)
      end
      it "フラッシュメッセージが表示されていること" do
        post :create, params: {user: {email: @user.email, password: @user.password, token: "token"}}
        expect(flash[:notice]).to eq "Googleによって、アクセスが中止されました"
      end
    end
  end
end
