require 'rails_helper'

RSpec.feature "Messages", type: :feature do
  scenario "メッセージを送信後、受信ユーザと送信ユーザでメッセージを確認できる" do
    user = FactoryBot.create(:user)
    partner = FactoryBot.create(:user)
    other_user = FactoryBot.create(:user)

    login_as(user)
    visit "users/#{partner.id}"
    click_link "メッセージを送る"

    expect{
      fill_in "メッセージを作成", with: "ジャムセッションしよう"
      click_on "送信"
      expect(find(".p-message__your_message")).to have_content "ジャムセッションしよう"

      click_link "マイページ"
      click_link "メッセージボックス"

      expect(page).to have_content partner.name
      expect(page).to have_content "ジャムセッションしよう"

      login_as(partner)
      visit root_path

      click_link "マイページ"
      click_link "メッセージボックス"

      expect(page).to have_content user.name
      expect(page).to have_content "ジャムセッションしよう"

      click_link user.name
      expect(find(".p-message__partner_message")).to have_content "ジャムセッションしよう"

      fill_in "メッセージを作成", with: "OK"
      click_on "送信"

      login_as(user)
      visit root_path
      click_link "マイページ"
      click_link "メッセージボックス"

      expect(page).to have_content partner.name
      expect(page).to have_content "OK"

      click_link partner.name

      expect(find(".p-message__your_message")).to have_content "ジャムセッションしよう"
      expect(find(".p-message__partner_message")).to have_content "OK"

      login_as(other_user)
      visit "users/#{partner.id}"
      expect(page).to_not have_content "ジャムセッションしよう"
      expect(page).to_not have_content "OK"

    }.to change(user.sent_messages, :count).by(1)

  end
  scenario "複数ユーザとメッセージにやり取りしている時、メッセージボックスにすべてのやり取りが表示される" do
    user = FactoryBot.create(:user)
    2.times do |i|
      @received_message = FactoryBot.create(:message, to_user_id: user.id, created_at: "Thu, 03 Sep 2020 20:0#{i}:00 JST +09:00")
      @sent_message = FactoryBot.create(:message, from_user_id: user.id, created_at: "Thu, 03 Sep 2020 20:0#{i}:01 JST +09:00")
    end
    login_as(user)
    visit root_path
    click_link "マイページ"
    click_link "メッセージボックス"

    expect(page).to have_selector(".p-message-list__content", count: 4)

    expect(all(".p-message-list__content")[0]).to have_content @sent_message.text
    expect(all(".p-message-list__content")[1]).to have_content @received_message.text
    expect(all(".p-message-list__content")[0]).to have_content @sent_message.text
    expect(all(".p-message-list__content")[1]).to have_content @received_message.text
  end

  context "マイページのメッセージに関するメニュー表示" do
    before do
      @user = FactoryBot.create(:user)
      @other_user = FactoryBot.create(:user)
    end
    scenario "未ログイン時" do
      visit "users/#{@user.id}"
      expect(page).to have_no_link("メッセージを送る")
      expect(page).to have_content("※メッセージの送信にはログインが必要です")

      visit "#{@other_user.id}"
      expect(page).to have_no_link("メッセージを送る")
      expect(page).to have_content("※メッセージの送信にはログインが必要です")
    end
    scenario "ログイン時" do
      login_as(@user)

      visit "users/#{@user.id}"
      expect(page).to have_link("メッセージボックス")
      expect(page).to_not have_content("※メッセージの送信にはログインが必要です")

      visit "#{@other_user.id}"
      expect(page).to have_link("メッセージを送る")
      expect(page).to_not have_content("※メッセージの送信にはログインが必要です")
    end
  end

end
