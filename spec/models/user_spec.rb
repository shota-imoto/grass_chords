require 'rails_helper'

RSpec.describe User, type: :model do
  it "nameがない場合は登録できないこと"
  it "nameの文字数が1文字の場合は登録されないこと"
  it "nameの文字数が2文字の場合は登録されること"
  it "nameの文字数が40文字の場合は登録されること"
  it "nameの文字数が41文字の場合は登録されないこと"
  it "emailがない場合は登録されないこと"
  it "すでに登録されているemailの場合は登録されないこと"
  it "すでに登録されているemailの最初の1文字を大文字に変えた場合でも登録されないこと"
  it "emailの文字数が2文字の場合は登録されないこと"
  it "emailの文字数が3文字の場合は登録されること"
  it "emailの文字数が254文字の場合は登録されること"
  it "emailの文字数が255文字の場合は登録されないこと"
  it "adminの値がtrueの場合は登録されないこと"
  it "placeの値が50文字の場合は登録されること"
  it "placeの値が51文字の場合は登録されないこと"
  it "adminの値がfalseの場合は登録されること"
  it "passwordがない場合は登録されないこと"
  it "passwordが存在してもpassword_confirmationがない場合は登録されないこと"
  it "passwordが5文字のときは登録されないこと"
  it "passwordが6文字のときは登録されること"
end
