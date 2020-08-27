require 'rails_helper'

RSpec.feature "Songs", type: :feature do
  scenario "ユーザーが新しい楽曲データを登録する", js: true  do
    user = FactoryBot.create(:user)

    login_as(user)

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

    login_as(user)

    visit root_path

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

    login_as(user)

    visit root_path

    all(".c-form__btn")[1].click
    click_link "Blue Ridge Cabin Home"
    click_link "Edit"

    expect(page).to have_content "あなたが作成したデータではありません"
    expect(page).to have_content "Edit"
  end

  scenario "ユーザーが楽曲データを削除する", js: true do
    user = FactoryBot.create(:user)
    song = FactoryBot.create(:song, title: "Blue Ridge Cabin Home", user_id: user.id)

    login_as(user)

    visit root_path

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

    login_as(user)

    visit root_path

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
    all(".c-form__btn")[1].click

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

  scenario "楽曲個別ページで1~3つ目のコード譜が正常に表示されている", js: true do
    song = FactoryBot.create(:song, title: "Blue Ridge Cabin Home")

    chord1 = FactoryBot.create(:chord, song_id: song.id)
    ($chordunit_num).times do |i|
      FactoryBot.create(:chordunit, address: i-1, chord_id: chord1.id)
    end

    chord2 = FactoryBot.create(:chord, song_id: song.id)
    ($chordunit_num).times do |i|
      FactoryBot.create(:chordunit, address: i-1, chord_id: chord2.id)
    end

    chord3 = FactoryBot.create(:chord, song_id: song.id)
    ($chordunit_num).times do |i|
      FactoryBot.create(:chordunit, address: i-1, chord_id: chord3.id)
    end

    visit "songs/#{song.id}"

    song.chords.each_with_index do |chord, i|
      total_index = $chordunit_num * (i)
      expect(all(".c-chordunit__part")[total_index]).to have_content "Intro"
      expect(all(".c-chordunit__part")[total_index]).to have_content "Solo"
      expect(all(".c-chordunit__repeat")[total_index]).to have_content "3."
      expect(all(".c-chordunit__indicator")[total_index]).to have_content "break"
      expect(all(".c-chordunit__beat")[total_index]).to have_content "@"
      expect(all(".c-chordunit__leftbar")[total_index]).to have_content "{"
      expect(all(".c-chordunit__note-name")[total_index]).to have_content "G"
      expect(all(".c-chordunit__half-note")[total_index]).to have_content "B"
      expect(all(".c-chordunit__modifier")[total_index]).to have_content "m"
      expect(all(".c-chordunit__rightbar")[total_index]).to have_content "}"
    end
  end

end
