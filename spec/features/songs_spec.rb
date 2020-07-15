require 'rails_helper'

RSpec.feature "Songs", type: :feature do
  scenario "ユーザーが新しい楽曲データを登録する" do
    user = FactoryBot.create(:user)

    visit root_path
    click_link "ログイン"
    fill_in "メール", with: user.email
    fill_in "パスワード", with: user.password
    click_button "ログイン"

    expect{
      click_link "楽曲の登録"
      fill_in "タイトル", with: "Blue Ridge Cabin Home"

      click_button "登録"

      expect(page).to have_content "楽曲を登録しました"
      expect(page).to have_content "Blue Ridge Cabin Home"


  }.to change(user.songs, :count).by(1)
  end

  scenario "ユーザーが新しい楽曲データを登録する", js: true  do
    user = FactoryBot.create(:user)

    visit user_session_path

    fill_in "メール", with: user.email
    fill_in "パスワード", with: user.password
    click_button "ログイン"

    visit new_song_path

    expect{
      fill_in "タイトル", with: "Blue Ridge Cabin Home"
      all(".c-js__attribute-btn")[0].click
      all(".c-js__attribute-btn")[2].click

      expect(all(".u-js__attribute-color").size).to eq(2)

      click_button "登録"

      expect(all(".u-js__attribute-color").size).to eq(2)

  }.to change(user.songs, :count).by(1)
  end

  scenario "ユーザーが楽曲データを変更する" do
    user = FactoryBot.create(:user)
    song = FactoryBot.create(:song, user_id: user.id)

    visit root_path
    click_link "ログイン"
    fill_in "メール", with: user.email
    fill_in "パスワード", with: user.password
    click_button "ログイン"

    expect{
      click_link "楽曲の登録"
      fill_in "タイトル", with: "Blue Ridge Mountain Girl"

      click_button "登録"

      expect(page).to have_content "楽曲を登録しました"

  }.to have_content "Blue Ridge Mountain Girl"

  end

  scenario "ユーザーが楽曲データを削除する"
  scenario "ユーザーが楽曲データを検索する" do
    # 3つデータを作成 →　検索結果を選択したあと属性値とタイトルを確認
  end
  scenario "メニューを開き、楽曲作成画面に移動 w/js"
  scenario "グローバルサーチを開き検索"

end
