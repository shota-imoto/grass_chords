require 'rails_helper'

RSpec.feature "Practices", type: :feature do

  scenario "練習ボタンの選択、userマイページの確認", js: true do
    user = FactoryBot.create(:user)

    song = FactoryBot.create(:song)
    chord = FactoryBot.create(:chord, song_id: song.id, practices_count: 10)

    song2 = FactoryBot.create(:song)
    chord2 = FactoryBot.create(:chord, song_id: song2.id, practices_count: 10)

    login_as(user)

    visit "songs/#{song.id}"

    all(".c-review__link")[0].click
    expect(page).to have_css(".c-js__practice")
    expect(find(".c-js__practice")).to have_content "11"

    all(".c-review__link")[0].click
    expect(page).to have_css(".c-js__not-practice")
    expect(find(".c-js__not-practice")).to have_content "10"

    all(".c-review__link")[0].click

    visit "songs/#{song2.id}"
    all(".c-review__link")[0].click

    find(".l-header__opn-box").click
    click_link "マイページ"

    expect(page).to have_content song.title
    expect(page).to have_content song2.title

    within(all(".p-user__song")[1]) do
      click_link "コード譜を見る"
    end
    expect(page).to have_current_path("/chords/#{chord2.id}")
    expect(page).to have_content song2.title

    find(".l-header__opn-box").click
    click_link "マイページ"

    within(all(".p-user__song")[0]) do
      find(".c-js__practice-delete").click
    end

    expect(page).to_not have_content song.title

    visit "songs/#{song.id}"

    expect(page).to_not have_css(".c-js__practice")
    expect(find(".c-js__not-practice")).to have_content "10"
  end

  scenario "ログイン時の練習ボタンの動作確認", js: true do
    user = FactoryBot.create(:user)
    song = FactoryBot.create(:song)

    3.times do |i|
      chord =FactoryBot.create(:chord, song_id: song.id, practices_count: 10)
    end

    visit "songs/#{song.id}"

    all(".c-review__btn")[2].click
    expect(page).to_not have_css(".c-js__practice")
    expect(all(".c-review__btn")[2]).to have_content "10"

    login_as(user)

    visit "songs/#{song.id}"

    all(".c-review__link")[2].click
    expect(page).to have_css(".c-js__practice")
    expect(all(".c-review__btn")[2]).to have_content "11"

    within(all(".p-song__score-wrapper")[0]) do
      click_link ">> 拡大ページ"
    end
    all(".c-review__link")[1].click
    expect(page).to_not have_css(".c-js__practice")
    expect(all(".c-review__btn")[0]).to have_content "10"
  end
end
