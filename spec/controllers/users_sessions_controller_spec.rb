require 'rails_helper'

RSpec.describe Users::SessionsController, type: :controller do
  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end
  # describe "#test_create" do
  #   before do
  #     @user = FactoryBot.create(:user, id: 0, name: "Earl Scruggs")
  #     allow(controller)
  #       .to receive(:current_user)
  #       .and_return(@user)
  #   end
  #   it "302レスポンスを返すこと" do
  #     get :test_create
  #     expect(response).to have_http_status "302"
  #   end
  #   it "rootにリダイレクトすること" do
  #     get :test_create
  #     expect(response).to redirect_to root_path
  #   end
  # end
  describe "#create" do
    before do
      @user = FactoryBot.create(:user)
      get_recaptcha_response = double("response")
      parse = double("")
      allow(get_recaptcha_response).to receive(:get_response)
    end
    it "ユーザーログインできること" do
      post :create, params: {email: @user.email, password: @user.password, token: "token"}
      expect(response).to have_http_status
    end
  end
end
