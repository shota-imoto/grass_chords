require 'rails_helper'

RSpec.describe MessagesController, type: :request do
  describe "#index" do
    before do
      message = FactoryBot.create(:message)
      @user = message.to_user
      @partner = message.from_user
    end
    it "正常にレスポンスを返すこと" do
      login_as(@user)
      get messages_path(to_user_id: @partner.id)
      expect(response).to be_successful
    end
    it "200レスポンスを返すこと" do
      login_as(@user)
      get messages_path(to_user_id: @partner.id)
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
      login_as(@user)
      get list_messages_path(id: @user.id)
      expect(response).to be_successful
    end
    it "200レスポンスを返すこと" do
      login_as(@user)
      get list_messages_path(id: @user.id)
      expect(response).to have_http_status "200"
    end
  end
  describe "#create" do
    before do
      @user = FactoryBot.create(:user)
      @partner = FactoryBot.create(:user)
    end
    it "messageレコードを登録できる" do
      login_as(@user)
      message_params = FactoryBot.attributes_for(:message, to_user_id: @partner.id)
      expect{
        post messages_path(message: message_params)
      }.to change(@partner.received_messages, :count).by(1)
    end
    it "message#indexにリダイレクトする" do
      login_as(@user)
      message_params = FactoryBot.attributes_for(:message, to_user_id: @partner.id)
      post messages_path(message: message_params)
      expect(response).to redirect_to messages_path(to_user_id: message_params[:to_user_id])
    end
  end

end
