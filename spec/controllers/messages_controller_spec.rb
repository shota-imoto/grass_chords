require 'rails_helper'

RSpec.describe MessagesController, type: :controller do
  describe "#index" do
    before do
      message = FactoryBot.create(:message)
      @user = message.to_user
      @partner = message.from_user
    end
    it "正常にレスポンスを返すこと" do
      sign_in @user
      get :index, params: {to_user_id: @partner.id}
      expect(response).to be_successful
    end
    it "200レスポンスを返すこと" do
      sign_in @user
      get :index, params: {to_user_id: @partner.id}
      expect(response).to have_http_status "200"
    end
  end
  describe "#list" do
    before do
      message = FactoryBot.create(:message)
      @user = message.to_user
      @partner = message.from_user
    end
    it "正常にレスポンスを返すこと" do
      sign_in @user
      get :list, params: {id: @user.id}
      # get :list, params: {to_user_id: @partner.id}
      expect(response).to be_successful
    end
    it "200レスポンスを返すこと" do
      sign_in @user
      get :list, params: {id: @user.id}
      expect(response).to have_http_status "200"
    end
  end
  describe "#create" do
    before do
      @user = FactoryBot.create(:user)
      @partner = FactoryBot.create(:user)
    end
    it "messageレコードを登録できる" do
      sign_in @user
      message_params = FactoryBot.attributes_for(:message, to_user_id: @partner.id)
      expect{
        post :create, params: {message: message_params}
      }.to change(@partner.received_messages, :count).by(1)
    end
    it "message#indexにリダイレクトする" do
      sign_in @user
      message_params = FactoryBot.attributes_for(:message, to_user_id: @partner.id)
      post :create, params: {message: message_params}
      expect(response).to redirect_to messages_path(to_user_id: message_params[:to_user_id])
    end
  end

end
