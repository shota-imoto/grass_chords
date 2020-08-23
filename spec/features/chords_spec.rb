require 'rails_helper'

RSpec.feature "Chords", type: :feature do
  scenario "コード譜の作成", js: true do
    user = FactoryBot.create(:user)
    song = FactoryBot.create(:song, title: "Blue Ridge Cabin Home")
    other_song = FactoryBot.create(:song, title: "Blue Moon of Kentucky")

    login_as(user)
    visit root_path

    expect{
      find(".l-header__opn-box").click
      all(".p-navi__content")[1].click
      click_link "コード譜"
      fill_in "曲名", with: "Bl"

      # キー切替テスト
      find(".c-key-change__present").click
      all(".c-key-change__btn")[9].click

      expect(find(".c-key-change__present")).to have_content "key of F"
      expect(find(".c-key-change__present").find(".font_base-key")).to have_content "B"

      all(".c-key-change__btn")[6].click
      all(".c-key-change__btn")[8].click
      all(".c-key-change__btn")[8].click
      all(".c-key-change__btn")[7].click

      expect(find(".c-key-change__present")).to have_content "key of G"
      expect(find(".c-key-change__present").find(".c-js__key-change--minor")).to have_content "m"

      find(".c-layer__skeleton").click

      # 楽曲の選択、バージョン名の入力(js動作待ちのためキー切替テスト後に実施)
      all(".c-song-candidate__list")[1].click
      fill_in "コード譜の名前", with: "standard"

      # コード譜入力テスト
      all(".c-chordunit")[0].click

      find(".p-chord-new__editor-btn").click
      all(".c-chord-edit__btn")[15].click
      all(".c-chord-edit__btn")[1].click
      all(".c-chord-edit__btn")[8].click
      all(".c-chord-edit__btn")[9].click
      all(".c-chord-edit__btn")[10].click
      all(".c-chord-edit__btn")[2].click
      all(".c-chord-edit__btn")[11].click
      all(".c-chord-edit__btn")[12].click

      expect(all(".c-chordunit__beat")[0]).to have_content "@"
      expect(all(".c-chordunit__note-name")[0]).to have_content "A"
      expect(all(".c-chordunit__half-note")[0]).to have_content "b"
      expect(all(".c-chordunit__modifier")[0]).to have_content "m7"
      expect(all(".c-chordunit__leftbar")[0]).to have_content "{"
      expect(all(".c-chordunit__rightbar")[0]).to have_content "}"

      expect(find(".c-chord-edit__text-window")).to have_content "Abm7B"

      find(".c-chord-edit__close").click
      all(".c-chordunit")[47].click
      find(".p-chord-new__editor-btn").click

      all(".c-chord-edit__btn")[3].click
      all(".c-chord-edit__btn")[7].click
      all(".c-chord-edit__btn")[7].click
      all(".c-chord-edit__btn")[9].click
      all(".c-chord-edit__btn")[12].click
      all(".c-chord-edit__btn")[12].click
      all(".c-chord-edit__btn")[16].click
      all(".c-chord-edit__btn")[17].click
      all(".c-chord-edit__btn")[4].click
      all(".c-chord-edit__btn")[19].click

      expect(find(".c-chord-edit__text-window")).to have_content "Cssm"

      find(".c-chord-edit__close").click
      # expect(all(".c-chordunit__beat")[47]).to have_content "#"
      expect(all(".c-chordunit__note-name")[47]).to have_content "C"
      expect(all(".c-chordunit__half-note")[47]).to have_content "B"
      expect(all(".c-chordunit__modifier")[47]).to have_content ""
      expect(all(".c-chordunit__rightbar")[47]).to have_content ""

      click_button "登録"

      expect(page).to have_content "コード譜を作成しました"
      expect(page).to have_content "Blue Ridge Cabin Home"
      expect(page).to have_content "standard version"


      expect(find(".c-key-change__present")).to have_content "key of Gm"

      expect(all(".c-chordunit__beat")[0]).to have_content "@"
      expect(all(".c-chordunit__note-name")[0]).to have_content "A"
      expect(all(".c-chordunit__half-note")[0]).to have_content "b"
      expect(all(".c-chordunit__modifier")[0]).to have_content "m7"
      expect(all(".c-chordunit__leftbar")[0]).to have_content "{"
      expect(all(".c-chordunit__rightbar")[0]).to have_content "}"

      # expect(all(".c-chordunit__beat")[47]).to have_content "#"
      expect(all(".c-chordunit__note-name")[47]).to have_content "C"
      expect(all(".c-chordunit__half-note")[47]).to have_content "B"
      expect(all(".c-chordunit__modifier")[47]).to have_content ""
      expect(all(".c-chordunit__rightbar")[47]).to have_content ""
    }.to change(song.chords, :count).by(1)
  end

  scenario "ユーザーがコード譜を編集する", js: true do
    user = FactoryBot.create(:user)
    song = FactoryBot.create(:song, title: "Blue Ridge Cabin Home")
    chord = FactoryBot.create(:chord, song_id: song.id, user_id: user.id)

    47.times do |i|
      FactoryBot.create(:chordunit, address: i, chord_id: chord.id)
    end
    chordunit = FactoryBot.create(:chordunit, address: 47, chord_id: chord.id)

    login_as(user)

    visit "chords/#{chord.id}"

    click_link "Edit"

    fill_in "コード譜の名前", with: "new"

    find(".c-key-change__present").click
    all(".c-key-change__btn")[9].click

    find(".c-layer__skeleton").click

    all(".c-chordunit")[47].click
    find(".p-chord-new__editor-btn").click

    all(".c-chord-edit__btn")[19].click
    all(".c-chord-edit__btn")[19].click
    all(".c-chord-edit__btn")[19].click

    all(".c-chord-edit__btn")[6].click
    all(".c-chord-edit__btn")[7].click

    find(".c-chord-edit__close").click
    click_button "登録"

    expect(page).to have_content "コード譜を編集しました"
    expect(page).to have_content "new version"

    expect(find(".c-key-change__present")).to have_content "key of F"
    expect(find(".c-key-change__present").find(".font_base-key")).to have_content "B"

    expect(all(".c-chordunit__beat")[0]).to have_content "@"
    expect(all(".c-chordunit__leftbar")[0]).to have_content "{"
    expect(all(".c-chordunit__note-name")[0]).to have_content "G"
    expect(all(".c-chordunit__half-note")[0]).to have_content "B"
    expect(all(".c-chordunit__modifier")[0]).to have_content "m"
    expect(all(".c-chordunit__rightbar")[0]).to have_content "}"

    expect(all(".c-chordunit__beat")[47]).to have_content "@"
    expect(all(".c-chordunit__leftbar")[47]).to have_content "{"
    expect(all(".c-chordunit__note-name")[47]).to have_content "F"
    expect(all(".c-chordunit__half-note")[47]).to have_content "B"
    expect(all(".c-chordunit__modifier")[47]).to have_content ""
    expect(all(".c-chordunit__rightbar")[47]).to have_content "}"

  end

  scenario "ユーザーがコード譜を編集しようとするも、オーナー権がなく更新できない" do
    user = FactoryBot.create(:user)
    other_user = FactoryBot.create(:user)
    song = FactoryBot.create(:song, title: "Blue Ridge Cabin Home")
    chord = FactoryBot.create(:chord, user_id: other_user.id)

    login_as(user)

    visit "chords/#{chord.id}"

    click_link "Edit"

    expect(page).to have_content "あなたが作成したデータではありません"
    expect(page).to have_content "Edit"
  end


  scenario "コード譜の削除" do
    user = FactoryBot.create(:user)
    song = FactoryBot.create(:song, title: "Blue Ridge Cabin Home")
    chord = FactoryBot.create(:chord, song_id: song.id, user_id: user.id)

    login_as(user)

    visit "chords/#{chord.id}"

    expect {
      click_link "Delete"

      expect(page).to have_content "コード譜を削除しました"
      expect(page).to have_current_path("/songs/#{song.id}")
    }.to change(song.chords, :count).by(-1)
  end

  scenario "ユーザーがコード譜を削除しようとするも削除できない" do
    user = FactoryBot.create(:user)
    other_user = FactoryBot.create(:user)
    song = FactoryBot.create(:song, title: "Blue Ridge Cabin Home")
    chord = FactoryBot.create(:chord, song_id: song.id, user_id: other_user.id)

    login_as(user)

    visit "chords/#{chord.id}"

    expect{
    click_link "Delete"

    expect(page).to have_content "あなたが作成したデータではありません"
    expect(page).to have_current_path("/chords/#{chord.id}")
     }.to change(song.chords, :count).by(0)
  end

  scenario "ユーザーがコード譜を削除しようとするもログインをしていないため削除できない" do
    song = FactoryBot.create(:song, title: "Blue Ridge Cabin Home")
    chord = FactoryBot.create(:chord, song_id: song.id)

    visit "chords/#{chord.id}"
    click_link "Delete"

    expect {
      expect(page).to have_content "ログイン後、操作してください"
      expect(page).to have_current_path(root_path)
    }.to change(song.chords, :count).by(0)
  end

  scenario "コード譜表示画面でキーを変更", js: true do
    user = FactoryBot.create(:user)
    song = FactoryBot.create(:song, title: "Blue Ridge Cabin Home")
    chord = FactoryBot.create(:chord, song_id: song.id, user_id: user.id)

    48.times do |i|
      FactoryBot.create(:chordunit, address: i, chord_id: chord.id)
    end

    visit "chords/#{chord.id}"

    find(".c-key-change__present").click
    all(".c-key-change__btn")[9].click
    all(".c-key-change__btn")[9].click

    expect(find(".c-key-change__present")).to have_content "key of F"

    expect(all(".c-chordunit__beat")[0]).to have_content "@"
    expect(all(".c-chordunit__note-name")[0]).to have_content "F"
    expect(all(".c-chordunit__half-note")[0]).to have_content "B"
    expect(all(".c-chordunit__modifier")[0]).to have_content "m"
    expect(all(".c-chordunit__leftbar")[0]).to have_content "{"
    expect(all(".c-chordunit__rightbar")[0]).to have_content "}"

    all(".c-key-change__btn")[8].click

    expect(find(".c-key-change__present")).to have_content "key of F"
    expect(find(".c-key-change__present").find(".font_base-key")).to have_content "B"

    expect(all(".c-chordunit__beat")[0]).to have_content "@"
    expect(all(".c-chordunit__note-name")[0]).to have_content "G"
    expect(all(".c-chordunit__half-note")[0]).to have_content ""
    expect(all(".c-chordunit__modifier")[0]).to have_content "m"
    expect(all(".c-chordunit__leftbar")[0]).to have_content "{"
    expect(all(".c-chordunit__rightbar")[0]).to have_content "}"

    all(".c-key-change__btn")[3].click

    expect(find(".c-key-change__present")).to have_content "key of C"

    expect(all(".c-chordunit__beat")[0]).to have_content "@"
    expect(all(".c-chordunit__note-name")[0]).to have_content "C"
    expect(all(".c-chordunit__half-note")[0]).to have_content ""
    expect(all(".c-chordunit__modifier")[0]).to have_content "m"
    expect(all(".c-chordunit__leftbar")[0]).to have_content "{"
    expect(all(".c-chordunit__rightbar")[0]).to have_content "}"
  end

  describe "楽曲個別ページからコード譜作成画面に移行に関わる操作" do
    context do
      scenario "コード譜を作成する", js: true do
        user = FactoryBot.create(:user)
        song = FactoryBot.create(:song, title: "Blue Ridge Cabin Home")

        login_as(user)
        visit "songs/#{song.id}"

        click_on "コード譜を作成する"

        expect{
          expect(find("#search_song_name").value).to match song.title

          all(".c-chordunit")[0].click
          find(".p-chord-new__editor-btn").click
          all(".c-chord-edit__btn")[0].click

          find(".c-chord-edit__close").click
          click_button "登録"

          expect(page).to have_content "コード譜を作成しました"
          expect(page).to have_content "Blue Ridge Cabin Home"
        }.to change(song.chords, :count).by(1)
      end
    end

    context "ログインしていない" do
      scenario "ログイン画面への移行が可能" do
        song = FactoryBot.create(:song, title: "Blue Ridge Cabin Home")
        visit "songs/#{song.id}"

        click_on "ログイン後、コード譜の登録が可能です"

        expect(page).to have_content "ログイン"
      end
    end
    context "表示確認" do
      scenario "ログインしている、かつコード譜が登録されている" do
        user = FactoryBot.create(:user)
        song = FactoryBot.create(:song, title: "Blue Ridge Cabin Home")
        chord = FactoryBot.create(:chord, song_id: song.id)

        login_as(user)
        visit "songs/#{song.id}"

        expect(find(".p-song__create_chord")).to_not have_css(".p-song__create_chord--no-login")
        expect(page).to_not have_content "ログイン後、コード譜の登録が可能です"
        expect(page).to_not have_content "この楽曲にはコード譜が登録されていません"
      end

      scenario "ログインしている、かつコード譜が登録されていない" do
        user = FactoryBot.create(:user)
        song = FactoryBot.create(:song, title: "Blue Ridge Cabin Home")

        login_as(user)
        visit "songs/#{song.id}"

        expect(find(".p-song__create_chord")).to_not have_css(".p-song__create_chord--no-login")
        expect(page).to_not have_content "ログイン後、コード譜の登録が可能です"
        expect(page).to have_content "この楽曲には、コード譜が登録されていません"
      end
      scenario "ログインしていない、かつコード譜が登録されている" do
        song = FactoryBot.create(:song, title: "Blue Ridge Cabin Home")
        chord = FactoryBot.create(:chord, song_id: song.id)

        visit "songs/#{song.id}"

        expect(find(".l-contents__main")).to have_css(".p-song__create_chord--no_login")
        expect(page).to have_content "ログイン後、コード譜の登録が可能です"
        expect(page).to_not have_content "この楽曲にはコード譜が登録されていません"
      end
      scenario "ログインしていない、かつコード譜が登録されていない" do
        song = FactoryBot.create(:song, title: "Blue Ridge Cabin Home")

        visit "songs/#{song.id}"

        expect(find(".l-contents__main")).to have_css(".p-song__create_chord--no_login")
        expect(page).to have_content "ログイン後、コード譜の登録が可能です"
        expect(page).to have_content "この楽曲には、コード譜が登録されていません"
      end
    end
  end
end
