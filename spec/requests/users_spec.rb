require 'rails_helper'

RSpec.describe UsersController, type: :request do
  describe "#show" do
    before do
      @user = FactoryBot.create(:user)
    end
    it "正常にレスポンスを返すこと" do
      get user_path(id: @user.id)
      expect(response).to be_successful
    end
    it "200レスポンスを返すこと" do
      get user_path(id: @user.id)
      expect(response).to have_http_status "200"
    end
  end

  describe "#search" do
    it "正常にレスポンスを返すこと" do
      get search_users_path
      expect(response).to be_successful
    end
    it "200レスポンスを返すこと" do
      get search_users_path
      expect(response).to have_http_status "200"
    end
  end
end
