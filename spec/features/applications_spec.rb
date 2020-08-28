require 'rails_helper'

RSpec.feature "applications", type: :feature do
  it "パンくずの表示確認" do
    user = FactoryBot.create(:user)
    song = FactoryBot.create(:song, user_id: user.id)
    chord = FactoryBot.create(:chord, user_id: user.id, song_id: song.id)

    visit new_user_session_path
    expect(find(".c-breadcrumbs")).to have_content "Home"
    expect(find(".c-breadcrumbs")).to have_content "ログイン"

    visit new_user_registration_path
    expect(find(".c-breadcrumbs")).to have_content "Home"
    expect(find(".c-breadcrumbs")).to have_content "ユーザ登録"

    login_as(user)

    visit user_path(user.id)
    expect(find(".c-breadcrumbs")).to have_content "Home"
    expect(find(".c-breadcrumbs")).to have_content "マイページ"

    visit edit_user_registration_path(id: user.id)
    expect(find(".c-breadcrumbs")).to have_content "Home"
    expect(find(".c-breadcrumbs")).to have_content "マイページ"
    expect(find(".c-breadcrumbs")).to have_content "ユーザ情報の編集"

    visit new_song_path
    expect(find(".c-breadcrumbs")).to have_content "Home"
    expect(find(".c-breadcrumbs")).to have_content "楽曲の登録"

    visit song_path(song)
    expect(find(".c-breadcrumbs")).to have_content "Home"
    expect(find(".c-breadcrumbs")).to have_content "検索"
    expect(find(".c-breadcrumbs")).to have_content song.title

    visit edit_song_path(song)
    expect(find(".c-breadcrumbs")).to have_content "Home"
    expect(find(".c-breadcrumbs")).to have_content "検索"
    expect(find(".c-breadcrumbs")).to have_content song.title
    expect(find(".c-breadcrumbs")).to have_content "楽曲の編集"

    visit new_chord_path
    expect(find(".c-breadcrumbs")).to have_content "Home"
    expect(find(".c-breadcrumbs")).to have_content "コード譜の作成"

    visit chord_path(chord)
    expect(find(".c-breadcrumbs")).to have_content "Home"
    expect(find(".c-breadcrumbs")).to have_content "検索"
    expect(find(".c-breadcrumbs")).to have_content song.title
    expect(find(".c-breadcrumbs")).to have_content "コード譜"

    visit edit_chord_path(chord)
    expect(find(".c-breadcrumbs")).to have_content "Home"
    expect(find(".c-breadcrumbs")).to have_content "検索"
    expect(find(".c-breadcrumbs")).to have_content song.title
    expect(find(".c-breadcrumbs")).to have_content "コード譜"
    expect(find(".c-breadcrumbs")).to have_content "コード譜の編集"
  end
end
