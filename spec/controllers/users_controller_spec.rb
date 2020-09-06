require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe "#show" do
    before do
      @user = FactoryBot.create(:user)
    end
    it "正常にレスポンスを返すこと" do
      get :show, params: {id: @user.id}
      expect(response).to be_successful
    end
    it "200レスポンスを返すこと" do
      get :show, params: {id: @user.id}
      expect(response).to have_http_status "200"
    end
  end

  describe "#search" do
    it "正常にレスポンスを返すこと" do
      get :search
      expect(response).to be_successful
    end
    it "200レスポンスを返すこと" do
      get :search
      expect(response).to have_http_status "200"
    end
  end
end
