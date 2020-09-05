require 'rails_helper'

RSpec.feature "Likes", type: :feature do
  scenario "信頼ボタンの選択、userマイページの確認", js: true do
    user = FactoryBot.create(:user)
    other_user = FactoryBot.create(:user)
    song = FactoryBot.create(:song, user_id: other_user.id)

    chord = FactoryBot.create(:chord, song_id: song.id, user_id: other_user.id, likes_count: 10)

    login_as(user)

    visit "songs/#{song.id}"

    all(".c-review__link")[1].click # 信頼できるボタンをクリック
    expect(page).to have_css(".c-js__like")
    expect(find(".c-js__like")).to have_content "11"

    all(".c-review__link")[1].click # 信頼できるボタンをクリック
    expect(page).to have_css(".c-js__not-like")
    expect(find(".c-js__not-like")).to have_content "10"

    all(".c-review__link")[1].click # 信頼できるボタンをクリック

    find(".l-header__opn-box").click
    click_link "マイページ"

    expect(page).to have_content song.title

    find(".l-header__opn-box").click
    click_link "ログアウト"

    login_as(other_user)

    visit root_path

    find(".l-header__opn-box").click
    click_link "マイページ"

    expect(find(".c-review__btn")).to have_content "11"
  end

  scenario "ログイン時の信頼ボタンの動作確認", js: true do
    user = FactoryBot.create(:user)
    song = FactoryBot.create(:song)

    3.times do |i|
      chord =FactoryBot.create(:chord, song_id: song.id, likes_count: 10)
    end

    visit "songs/#{song.id}"

    all(".c-review__btn")[3].click
    expect(page).to_not have_css(".c-js__like")
    expect(all(".c-review__btn")[3]).to have_content "10"

    login_as(user)

    visit "songs/#{song.id}"

    all(".c-review__link")[3].click
    expect(page).to have_css(".c-js__like")
    expect(all(".c-review__btn")[3]).to have_content "11"

    within(all(".p-song__score-wrapper")[1]) do
      click_link ">> 拡大ページ"
    end
    all(".c-review__link")[1].click
    expect(page).to_not have_css(".c-js__like")
    expect(all(".c-review__btn")[1]).to have_content "10"
  end
end
