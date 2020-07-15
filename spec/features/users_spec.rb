require 'rails_helper'

RSpec.feature "Users", type: :feature do
  scenario "マイページで練習曲リストの削除"
  scenario "お試しログイン"
  scenario "ユーザ登録" do
    # トップ画面→メニューに楽曲登録が存在しないことを確認
    # →ユーザ登録画面へ→トップ画面にリダイレクト→メニューに楽曲登録が存在することを確認
    # ログアウトする→メニューrに楽曲登録が存在しないことを確認
    # ユーザデータが増えていることを確認
  end
end
