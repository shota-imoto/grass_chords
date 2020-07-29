require 'rails_helper'
      # save_and_open_page

RSpec.feature "Songs", type: :feature do
  scenario "ユーザーが新しい楽曲データを登録する", js: true  do
    user = FactoryBot.create(:user)

    sign_in user

    # visit root_path
    # all(".l-header__opn-box")[0].click
    # click_link "ログイン"

    # fill_in "メール", with: user.email
    # fill_in "パスワード", with: user.password
    # click_button "ログイン"

    visit new_song_path

    expect{
      fill_in "タイトル", with: "Blue Ridge Cabin Home"
      all(".c-js__attribute-btn")[0].click
      all(".c-js__attribute-btn")[2].click

      expect(all(".u-js__attribute-color").size).to eq(2)

      click_button "登録"

      expect(page).to have_content "楽曲を登録しました"
      expect(page).to have_content "Blue Ridge Cabin Home"
      expect(all(".u-js__attribute-color").size).to eq(2)

  }.to change(user.songs, :count).by(1)
  end

  scenario "ユーザーが楽曲データを変更する", js: true do
    user = FactoryBot.create(:user)
    song = FactoryBot.create(:song, title: "Blue Ridge Cabin Home", user_id: user.id)

    visit root_path
    all(".l-header__opn-box")[0].click

    click_link "ログイン"
    fill_in "メール", with: user.email
    fill_in "パスワード", with: user.password
    click_button "ログイン"

    all(".c-form__btn")[1].click
    click_link "Blue Ridge Cabin Home"
    click_link "Edit"

    fill_in "タイトル", with: "Blue Ridge Mountain Girl"
    all(".c-js__attribute-btn")[0].click
    all(".c-js__attribute-btn")[1].click
    all(".c-js__attribute-btn")[2].click
    click_button "登録"


    expect(page).to have_content "楽曲を更新しました"
    expect(page).to have_content "Blue Ridge Mountain Girl"
    expect(all(".u-js__attribute-color").size).to eq(3)
  end

  scenario "ユーザーが楽曲データを変更しようとするが、オーナー権限がなく失敗する" do
    user = FactoryBot.create(:user)
    other_user = FactoryBot.create(:user)
    song = FactoryBot.create(:song, title: "Blue Ridge Cabin Home", user_id: other_user.id)


    visit root_path

    click_link "ログイン"
    fill_in "メール", with: user.email
    fill_in "パスワード", with: user.password
    click_button "ログイン"

    all(".c-form__btn")[1].click
    click_link "Blue Ridge Cabin Home"
    click_link "Edit"

    expect(page).to have_content "あなたが作成したデータではありません"
    expect(page).to have_content "Edit"
  end

  scenario "ユーザーが楽曲データを削除する", js: true do
    user = FactoryBot.create(:user)
    song = FactoryBot.create(:song, title: "Blue Ridge Cabin Home", user_id: user.id)

    visit root_path

    all(".l-header__opn-box")[0].click

    click_link "ログイン"
    fill_in "メール", with: user.email
    fill_in "パスワード", with: user.password
    click_button "ログイン"

    expect{
      all(".c-form__btn")[1].click
      click_link "Blue Ridge Cabin Home"
      click_link "Delete"
      page.accept_confirm "本当によろしいですか？"
      expect(page).to have_content "楽曲を削除しました"
      expect(page).to have_content "Concept"

    }.to change(user.songs, :count).by(-1)
  end

  scenario "ユーザーが楽曲データを削除しようとするが、オーナー権限がなく失敗する" do
    user = FactoryBot.create(:user)
    other_user = FactoryBot.create(:user)
    song = FactoryBot.create(:song, title: "Blue Ridge Cabin Home", user_id: other_user.id)


    visit root_path

    click_link "ログイン"
    fill_in "メール", with: user.email
    fill_in "パスワード", with: user.password
    click_button "ログイン"

    all(".c-form__btn")[1].click
    click_link "Blue Ridge Cabin Home"
    click_link "Delete"

    expect(page).to have_content "あなたが作成したデータではありません"
    expect(page).to have_content "Delete"
  end
  scenario "ユーザーが楽曲データを検索する", js: true do
    visit root_path

    song1 = FactoryBot.create(:song, title: "Blue Ridge Cabin Home", jam: true)
    song2 = FactoryBot.create(:song, title: "Blue Ridge Mountain Girl", standard: true)
    song3 = FactoryBot.create(:song, title: "Little Cabin Home on the Hill", beginner: true)

    fill_in "曲名で検索", with: "Blue"
    all(".c-form__btn")[1].click
    expect(page).to have_content "Blue Ridge Cabin Home"
    expect(page).to have_content "Blue Ridge Mountain Girl"
    expect(page).to have_content "2 results.."
    expect(all(".p-search-result__result").size).to eq(2)
    all(".c-js__attribute-btn")[0].click
    expect(page).to have_content "Blue Ridge Cabin Home"
    expect(page).to have_content "1 results.."
    expect(all(".p-search-result__result").size).to eq(1)
  end

  scenario "アルファベット順/練習している人数順ソートの機能確認" do
    song1 = FactoryBot.create(:song, title: "SongA", practice_songs_count: 20)
    song2 = FactoryBot.create(:song, title: "SongB", practice_songs_count: 50)
    song3 = FactoryBot.create(:song, title: "SongC", practice_songs_count: 30)
    song4 = FactoryBot.create(:song, title: "SongE", practice_songs_count: 60)
    song5 = FactoryBot.create(:song, title: "SongD", practice_songs_count: 20)

    visit root_path

    all(".c-form__btn")[1].click

    expect(all(".p-search-result__result")[0]).to have_content "SongA"
    expect(all(".p-search-result__result")[1]).to have_content "SongB"
    expect(all(".p-search-result__result")[2]).to have_content "SongC"
    expect(all(".p-search-result__result")[3]).to have_content "SongD"
    expect(all(".p-search-result__result")[4]).to have_content "SongE"

    all(".p-search-result__sort-btn")[1].click

    all(".c-form__btn")[1].click

    expect(all(".p-search-result__result")[0]).to have_content "SongE"
    expect(all(".p-search-result__result")[1]).to have_content "SongB"
    expect(all(".p-search-result__result")[2]).to have_content "SongC"
    expect(all(".p-search-result__result")[3]).to have_content "SongA"
    expect(all(".p-search-result__result")[4]).to have_content "SongD"
  end

  scenario "グローバルサーチを開き検索", js: true do
    song = FactoryBot.create(:song, title: "Blue Ridge Cabin Home")

    visit root_path


    find(".l-header__search-btn").click
    all(".c-form__btn")[3].click
    expect(page).to have_content "Blue Ridge Cabin Home"
    expect(all(".p-search-result__result").size).to eq(1)
  end

end
