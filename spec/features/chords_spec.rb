require 'rails_helper'

RSpec.feature "Chords", type: :feature, js: true do
  scenario "コード譜の作成" do
    user = FactoryBot.create(:user)
    song = FactoryBot.create(:song, title: "Blue Ridge Cabin Home")
    other_song = FactoryBot.create(:song, title: "Blue Moon of Kentucky")

    visit root_path
    find(".l-header__opn-box").click
    click_link "ログイン"

    fill_in "メール", with: user.email
    fill_in "パスワード", with: user.password
    click_button "ログイン"


    find(".l-header__opn-box").click
    all(".p-navi__content")[1].click
    click_link "コード譜"
    fill_in "曲名", with: "Blue"
    all(".c-song-candidate__list")[1].click
    fill_in "コード譜の名前", with: "standard"
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



  #   F→＃３回→7の順にクリック
  # chordunitの４８個目が正しく表示されていることを確認（G＃7）
  #   keyボタンをクリック
  #   F→＃３回の順番にクリック
  #   keyが正しく表示されていることを確認する（G＃）
  #   登録ボタンをクリック
  #   画面遷移を確認
  #   メッセージの表示を確認
  #   タイトルが一致していることを確認
  #   keyが登録したC＃となっているか確認
  #   chordunitの1つ目に適切に文字が表示されていることを確認
  #   chordunitの48個目に適切に文字が表示されていることを確認
  # }.to chordレコードの生成を確認

  end
  scenario "ユーザーがコード譜を編集する w/js" do
  #   user = FactoryBot.create(:user)
  #   chord譜データを作成
  #   chordunitデータを作成(address1個目48個目)
  #   ログイン操作（コピペ）
  #   expect{
  #     検索ウィンドウに文字列を入力
  #     表示された楽曲データをクリック
  #     編集ボタンをクリック
  #     chordunitの48個目をクリック
  #     バックスペースボタンを3回クリック
  #     F→＃クリック
  #     登録ボタンをクリック
  #     メッセージの表示を確認
  #     キーと48個目が変更されているか確認
  #     1個目が変更されていないことを確認
  # }.to　データの変更を確認
  end
  scenario "ユーザーがコード譜を編集しようとするも、オーナー権がなく更新できない" do
      #   chord譜データを作成
  #   chordunitデータを作成(address1個目48個目)
  #   ログイン操作（コピペ）
  #   expect{
      #     検索ウィンドウに文字列を入力
  #     表示された楽曲データをクリック
  #     編集ボタンをクリック
  # オーナー権限がなくリダイレクトバックされる
  # メッセージの表示を確認
  # 画面が楽曲個別ページであることを確認
  # }.to データの変更がないことを確認

  end


  scenario "コード譜の削除" do
    # userデータを生成
          #   chord譜データを作成
  #   chordunitデータを作成(address1個目48個目)
  #   ログイン操作（コピペ）
  #   expect{
      #     検索ウィンドウに文字列を入力
  #     表示された楽曲データをクリック
  # 削除ボタンをクリック
  # 画面遷移
  # メッセージの表示を確認
  # リダイレクト先の画面表示を確認
  # }.to データの削除を確認
  end
  scenario "ユーザーがコード譜を削除しようとするも削除できない" do
    # userデータを生成
    # other_userデータを生成
              #   chord譜データを作成
  #   chordunitデータを作成(address1個目48個目)
  #   ログイン操作（コピペ）
  #   expect{
      #     検索ウィンドウに文字列を入力
  #     表示された楽曲データをクリック
  # 削除ボタンをクリック
  # 画面遷移
  # メッセージの表示を確認
  # リダイレクト先の画面表示を確認
  # }.to データの削除を確認
  end

  scenario "ユーザーがコード譜を削除しようとするもログインをしていないため削除できない" do
              #   chord譜データを作成
  #   chordunitデータを作成(address1個目48個目)
    #   ログイン操作（コピペ）
  #   expect{
      #     検索ウィンドウに文字列を入力
  #     表示された楽曲データをクリック
  # 削除ボタンをクリック
  # 画面遷移
  # メッセージの表示を確認
  # リダイレクト先の画面表示を確認
  # }.to データの削除を確認
  end
  scenario "コード譜表示画面でキーを変更" do
                  #   chord譜データを作成
  #   chordunitデータを作成(address1個目48個目)
  # キーボタンをクリック
  # キーを変更
  # chordunitの表示値を確認:F＃を半音上げるとGになること、mは変更されていないこと、Gを半音下げるとF＃になること
  end
end
