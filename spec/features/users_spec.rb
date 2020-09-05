require 'rails_helper'
RSpec.feature "Users", type: :feature do
  scenario "お試しログイン" do
    user = FactoryBot.create(:user, id: 0)
    other_user = FactoryBot.create(:user)

    visit root_path
    expect(page).to_not have_content "マイページ"
    expect(page).to_not have_content "データ作成"

    click_link "ログイン"
    click_link "お試しログイン"

    expect(page).to have_content "お試しログインに成功しました"
    expect(page).to have_content "マイページ"
    expect(page).to have_content "データ作成"

    click_link "マイページ"

    expect(page).to have_content user.name
    expect(page).to have_content user.email
    expect(page).to have_content user.place.name

    visit "#{other_user.id}"

    expect(page).to have_content other_user.name
    expect(page).to_not have_content other_user.email
    expect(page).to have_content other_user.place.name

    # ログアウトテスト
    click_link "ログアウト"
    expect(page).to have_content "ログアウトしました"

    expect(page).to_not have_content "マイページ"
    expect(page).to_not have_content "データ作成"
  end
  context "ユーザ登録" do
    before do
      response_mock = Net::HTTPOK.new(nil, 200, "OK")
      http_obj = double("Net::HTTP")
      recaptcha_mock = '{ "success": true, "challenge_ts": "2020-08-01T03:00:35Z", "hostname": "localhost", "score": 0.9, "action": "submit"}'
      allow(Net::HTTP).to receive(:get_response).and_return(response_mock)
      allow(response_mock).to receive(:body).and_return(recaptcha_mock)
    end
    scenario "活動拠点を選択した場合" do

      user = FactoryBot.build(:user)
      visit root_path

      expect(page).to_not have_content "マイページ"
      expect(page).to_not have_content "データ作成"

      expect{
      click_link "ユーザ登録"

      fill_in "名前", with: user.name
      select user.place.name, from: "user_place_id" #活動拠点を選択する
      fill_in "メール", with: user.email
      fill_in "パスワード", with: user.password
      fill_in "パスワード(確認)", with: user.password

      click_button "登録"

      expect(page).to have_current_path(root_path)
      expect(page).to have_content "ようこそ！ アカウントが登録されました"
      expect(page).to have_content "マイページ"
      expect(page).to have_content "データ作成"

      click_link "マイページ"

      expect(page).to have_content user.name
      expect(page).to have_content user.email
      expect(page).to have_content user.place.name

    }.to change(User, :count).by(1)
    end
    scenario "活動拠点を選択しなかった場合" do

      user = FactoryBot.build(:user)
      visit root_path

      expect(page).to_not have_content "マイページ"
      expect(page).to_not have_content "データ作成"

      expect{
      click_link "ユーザ登録"

      fill_in "名前", with: user.name
      fill_in "メール", with: user.email
      fill_in "パスワード", with: user.password
      fill_in "パスワード(確認)", with: user.password

      click_button "登録"

      expect(page).to have_current_path(root_path)
      expect(page).to have_content "ようこそ！ アカウントが登録されました"
      expect(page).to have_content "マイページ"
      expect(page).to have_content "データ作成"

      click_link "マイページ"

      expect(page).to have_content user.name
      expect(page).to have_content user.email
      expect(page).to have_content "未設定"

      click_link "Edit"
      expect(page).to have_select("user[place_id]", selected: nil)


    }.to change(User, :count).by(1)
    end
  end

  scenario "ユーザー情報の編集・削除" do
    user = FactoryBot.create(:user, id: 1)

    login_as(user)
    visit root_path

    click_link "マイページ"
    click_link "Edit"

    expect{
      expect(page).to have_select("user[place_id]", selected: user.place.name)

      fill_in "名前", with: "New Name"
      select "沖縄県", from: "user_place_id" #活動拠点を選択する
      fill_in "現在のパスワード", with: user.password

      click_button "登録"

      expect(page).to have_current_path(root_path)
      expect(page).to have_content "アカウントが更新されました"

      click_link "マイページ"

      expect(page).to have_content "New Name"
      expect(page).to have_content "沖縄県"

      click_link "Edit"

      click_button "ユーザを削除する"

      expect(page).to have_content "ご利用ありがとうございました。アカウント情報が削除されました"
    }.to change(User, :count).by(-1)
  end

  context "ユーザー情報の更新に成功する" do
    before do
      @user = FactoryBot.create(:user, password: "Old Password")
    end
    scenario "password以外の情報を変更し、現在のパスワードを入力しない" do
      login_as(@user)
      visit root_path

      click_link "マイページ"
      click_link "Edit"

      fill_in "名前", with: "New Name"
      click_button "登録"

      expect(page).to have_current_path(root_path)
      expect(page).to have_content "アカウントが更新されました"

      click_link "マイページ"

      expect(page).to have_content "New Name"
    end
    scenario "password以外の情報とpasswordを変更し、確認用パスワードと現在のパスワードを入力する" do
      login_as(@user)
      visit root_path

      click_link "マイページ"
      click_link "Edit"

      fill_in "名前", with: "New Name"
      fill_in "新しいパスワード", with: "New Password"
      fill_in "新しいパスワード(確認)", with: "New Password"
      fill_in "現在のパスワード", with: @user.password

      click_button "登録"

      expect(page).to have_current_path(root_path)
      expect(page).to have_content "アカウントが更新されました"

      click_link "マイページ"

      expect(page).to have_content "New Name"
    end
  end
  context "ユーザー情報の更新に失敗する" do
    before do
      @user = FactoryBot.create(:user, password: "Old Password")
    end
    scenario "password以外の情報とpasswordを変更し、確認用パスワードを入力するが現在のパスワードを入力しないredirect" do
      login_as(@user)
      visit root_path

      click_link "マイページ"
      click_link "Edit"

      fill_in "名前", with: "New Name"
      fill_in "新しいパスワード", with: "New Password"
      fill_in "新しいパスワード(確認)", with: "New Password"

      click_button "登録"

      expect(page).to have_current_path(edit_user_registration_path(id: @user.id))
      expect(page).to have_content "パスワードを変更する際は、現在のパスワードを入力してください"

      visit root_path
      click_link "マイページ"

      expect(page).to have_content @user.name
    end
    scenario "passwordを変更し、現在のパスワードを入力するが、確認用パスワードを入力しない" do
      login_as(@user)
      visit root_path

      click_link "マイページ"
      click_link "Edit"

      fill_in "名前", with: "New Name"
      fill_in "新しいパスワード", with: "New Password"
      fill_in "現在のパスワード", with: @user.password

      click_button "登録"

      expect(page).to have_current_path("/users")

      visit root_path
      click_link "マイページ"

      expect(page).to have_content @user.name
    end
    scenario "確認用パスワードを入力し、現在のパスワードを入力するが、passwordを変更しない" do
      login_as(@user)
      visit root_path

      click_link "マイページ"
      click_link "Edit"

      fill_in "名前", with: "New Name"
      fill_in "新しいパスワード(確認)", with: "New Password"
      fill_in "現在のパスワード", with: @user.password

      click_button "登録"

      expect(page).to have_current_path("/users")

      visit root_path
      click_link "マイページ"

      expect(page).to have_content @user.name
    end
  end

  scenario "テストユーザーはユーザー情報を編集することも削除することもできない" do
    user = FactoryBot.create(:user, id: 0)

    visit root_path
    click_link "ログイン"
    click_link "お試しログイン"

    click_link "マイページ"
    click_link "Edit"

    expect {
    fill_in "名前", with: "New Name"
    fill_in "現在のパスワード", with: user.password

    click_button "登録"

    expect(page).to have_current_path(edit_user_registration_path(id: user.id))
    expect(page).to have_content "テストユーザーは編集できません"

    click_button "ユーザを削除する"

    expect(page).to have_current_path(edit_user_registration_path(id: user.id))
    expect(page).to have_content "テストユーザーは編集できません"
  }.to change(User, :count).by(0)
  end

  scenario "ログイン画面からユーザ登録画面への移行" do
    visit edit_user_registration_path

    click_link "こちら"

    expect(page).to have_content "ユーザ登録"
  end

  context "ユーザ検索" do
    before do
      @user1 = FactoryBot.create(:user, place_id: 2) # 青森県　東北
      @user2 = FactoryBot.create(:user, place_id: 2)
      @user3 = FactoryBot.create(:user, place_id: 3) # 岩手県　東北
      @user4 = FactoryBot.create(:user, place_id: 8) # 茨城県　関東

      @song1 = FactoryBot.create(:song, title: "Blue Ridge Cabin Home", user_id: @user1.id)
      @song2 = FactoryBot.create(:song, title: "You're My Shunshine", user_id: @user1.id)
      chord1 = FactoryBot.create(:chord, song_id: @song1.id, user_id: @user1.id)
      chord2 = FactoryBot.create(:chord, song_id: @song2.id, user_id: @user1.id)

      FactoryBot.create(:practice_song, song_id: @song1.id, user_id: @user1.id)
      FactoryBot.create(:practice_song, song_id: @song2.id, user_id: @user2.id)
      FactoryBot.create(:practice_song, song_id: @song1.id, user_id: @user3.id)
      FactoryBot.create(:practice_song, song_id: @song1.id, user_id: @user4.id)
    end
    scenario "練習している曲名から探す", js: true do
      visit root_path

      # グローバルナビを開く
      find(".l-header__opn-box").click

      click_link "ユーザ検索"

      # 初期画面表示
      expect(all(".p-search-user__result").size()).to eq(4)
      expect(page).to have_content @user1.name
      expect(page).to have_content @user1.place.name

      expect(page).to have_content @user2.name
      expect(page).to have_content @user3.name
      expect(page).to have_content @user4.name


      all(".c-form__btn")[1].click # 検索ボタンのクリック

      # 空欄検索結果の確認
      expect(all(".p-search-user__result").size()).to eq(4)
      expect(page).to have_content @user1.name
      expect(page).to have_content @user2.name
      expect(page).to have_content @user3.name
      expect(page).to have_content @user4.name

      fill_in "曲名", with: "b" #=>js動作

      # wait動作のためのテストケース
      expect(page).to have_content("Blue Ridge Cabin Home")

      all(".c-song-candidate__list")[0].click # 楽曲の選択
      all(".c-form__btn")[1].click # 検索ボタンのクリック

      # 練習曲検索結果の確認
      expect(all(".p-search-user__result").size()).to eq(3)
      expect(page).to have_content @user1.name
      expect(page).to have_content @user3.name
      expect(page).to have_content @user4.name

      find(".p-search-user__place-open").click #=>js動作 # 「活動地域から検索する」をクリック
      # wait動作のためのテストケース
      expect(page).to have_css(".p-search-user__place-wrapper")
      check @user1.place.name # 青森県
      all(".c-form__btn")[3].click # 検索ボタンのクリック

      # 練習曲+地名検索結果の確認
      expect(all(".p-search-user__result").size()).to eq(1)
      expect(page).to have_content @user1.name

      # fill_in "曲名", with: ""

      # # for delete song_candidate(song_candidate is being shown because autoinput is too fast.)
      # fill_in "曲名", with: "x"

      find(".l-header__opn-box").click

      click_link "ユーザ検索"

      find(".p-search-user__place-open").click #=>js動作 # 「活動地域から検索する」をクリック
      # wait動作のためのテストケース
      expect(page).to have_css(".p-search-user__place-wrapper")
      check @user1.place.name # 青森県
      check @user3.place.name # 岩手県

      all(".c-form__btn")[3].click # 検索ボタンのクリック

      # 地名複数検索(同じareaに紐づくplace)結果の確認
      expect(all(".p-search-user__result").size()).to eq(3)
      expect(page).to have_content @user1.name
      expect(page).to have_content @user3.name

      find(".p-search-user__place-open").click #=>js動作 # 「活動地域から検索する」をクリック
      # wait動作のためのテストケース
      expect(page).to have_css(".p-search-user__place-wrapper")

      check @user1.place.name # 青森県
      check @user4.place.name # 茨木県

      find(".for_capybara_test_class").click
      expect(page).to have_content "青森県, 茨城県"
      all(".c-form__btn")[1].click # 検索ボタンのクリック

      # 地名複数検索(別のarea紐づくplace)結果の確認
      expect(all(".p-search-user__result").size()).to eq(3)
      expect(page).to have_content @user1.name
      expect(page).to have_content @user4.name
    end
  end
end
