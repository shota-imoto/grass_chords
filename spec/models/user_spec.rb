require 'rails_helper'

RSpec.describe User, type: :model do
  describe "全属性のバリデーション" do
    let(:user) {FactoryBot.build(:user)}
    subject{user}

    context "name, place, email, passwordがある場合" do
      it {is_expected.to be_valid}
    end
  end

  describe "nameのバリデーション" do
    let(:user) {FactoryBot.build(:user, name: name)}
    context "登録される" do
      subject{user}

      context "nameの文字数が2文字の場合" do
        let(:name) {"JM"}
        it {is_expected.to be_valid}
      end

      context "nameの文字数が40文字の場合" do
        let(:name) {"ABCDEFGHIJKLMNOPQRSTUVWXYZABCDEFGHIJKLMN"}
        it {is_expected.to be_valid}
      end
    end

    context "登録されない" do
      subject{user.errors[:name]}
      before do
        user.valid?
      end
      context "nameがない場合" do
        let(:name) {nil}
        it {is_expected.to include("が空欄です")}
      end

      context "nameの文字数が1文字の場合" do
        let(:name) {"J"}
        it {is_expected.to include("は2~40文字に設定してください")}
      end
      context "nameの文字数が41文字の場合" do
        let(:name) {"ABCDEFGHIJKLMNOPQRSTUVWXYZABCDEFGHIJKLMNO"}
        it {is_expected.to include("は2~40文字に設定してください")}
      end

      context "すでに登録されているnameの場合は登録されないこと" do
        let(:name) {"Jim Mills"}

        before do
          FactoryBot.create(:ricky, name: "Jim Mills")
          user.valid?
        end
        it {is_expected.to include("は既に登録されています")}
      end
    end
  end

  describe "emailのバリデーション" do
    let(:user) {FactoryBot.build(:user, email: email)}
    context "登録される" do
      subject {user}
      context "emailの文字数が3文字の場合" do
        let(:email) {"b@b"}
        it {is_expected.to be_valid}
      end
      context "emailの文字数が354文字の場合" do
        let(:email) {"ydih7aTzftql6KoW0hZKzvO9KMf82CkbvAKmjSUAeGnchnt98XRk1QL9TazFIxfL4wxJvrvkchhJDPaAzVcg5dCKK8L8YSQIELop@vcctPBLh3Ys8LZ1zBPRLm7BNCx7rU5okBFhuXg3QkKRWBE9i0AUk8TCIGANOrG9MBxmOB7ygOVj60BgvcdMDKuM64QdKuffnKPGrXDDvzQVfBgWKrQJNRBCfqt3GqrINpp3sXY7ezJ4OoB7EOTkjROry6"}
        it {is_expected.to be_valid}
      end
    end
    context "登録されない" do
      subject{user.errors[:email]}
      before do
        user.valid?
      end
      context "emailがない場合" do
        let(:email) {nil}
        it {is_expected.to include("を入力してください")}
      end
      context "すでに登録されているemialの場合" do
        let(:email) {"bound_ride@bluegrass.com"}
        before do
          FactoryBot.create(:ricky, email: "bound_ride@bluegrass.com")
          user.valid?
        end
        it {is_expected.to include("は既に登録されています")}
      end
      context "すでに登録されているemialの最初の1文字を大文字に変えた場合" do
        let(:email) {"Bound_ride@bluegrass.com"}
        before do
          FactoryBot.create(:ricky, email: "bound_ride@bluegrass.com")
          user.valid?
        end
        it {is_expected.to include("は既に登録されています")}
      end
      context "emailの文字数が2文字の場合" do
        let(:email) {"b@"}
        it {is_expected.to include("は254文字以内のものを登録してください")}
      end
      context "emailの文字数が255文字の場合" do
        let(:email) {"RB9thr2On5XIihPibexjIDilMsY1iNuHQEswR73Oml3MHEIpnt3GNogzjbpTt7a0yjNQTo9QmeXjRurXtxysAB8gJIdufMmeuw0jaMh@3IEdy2Qs0xsX9wbuZssRgriJgVniAmXL4GtAdwrs4VtKqLnkSznbZSiwGmKRGE3jIrdefNQKt6w6CLY1RDSkAm77OBKAVrlIM9fb6EaEpKh4e3zn3aCQFbi4ePttqWpnHvDQ7s65nM8uYNE9wnwgFOd"}
        it {is_expected.to include("は254文字以内のものを登録してください")}
      end
    end
  end

  describe "adminのバリデーション" do
    let(:user) {FactoryBot.build(:user, admin: admin)}
    context "登録される" do
      subject {user}
      context "adminの値が空欄の場合" do
        let(:admin) {nil}
        it {is_expected.to be_valid}
      end
      context "adminの値がfalseの場合" do
        let(:admin) {false}
        it {is_expected.to be_valid}
      end
    end

    context "登録されない" do
      subject {user.errors[:admin]}
      before do
        user.valid?
      end
      context "adminの値がtrueの場合" do
        let(:admin) {true}
        it {is_expected.to include("システムエラー：不正な値が入力されました")}
      end
    end
  end

  describe "place_idのバリデーション" do
    let(:user) {FactoryBot.build(:user, place_id: place_id)}
    context "登録される" do
      subject {user}
      context "placeの値が設定されている場合" do
        let(:place_id) {1}
        it {is_expected.to be_valid}
      end
    end
    context "登録されない" do
      subject {user.errors[:place_id]}
      before do
        user.valid?
      end
      context "placeの値が空欄の場合" do
        let(:place_id) {nil}
        it {is_expected.to include("システムエラー：不正な値が入力されました")}
      end
    end
  end

  describe "passwordのバリデーション" do
    let(:user) {FactoryBot.build(:user, password: password, password_confirmation: password_confirmation)}
    context "登録される" do
      subject {user}
      context "passwordが6文字の場合" do
        let(:password) {"123456"}
        let(:password_confirmation) {"123456"}
        it {is_expected.to be_valid}
      end
    end
    context "登録されない" do
      subject {user.errors[:password]}
      before do
        user.valid?
      end
      context "passwordがない場合" do
        let(:password) {nil}
        let(:password_confirmation) {nil}
        it {is_expected.to include("を入力してください")}
      end
      context "passwordが存在してもpassword_confirmationが一致しない場合" do
        subject {user.errors[:password_confirmation]}
        let(:password) {"123456"}
        let(:password_confirmation) {"654321"}
        it {is_expected.to include("とパスワードの入力が一致しません")}
      end

      context "passwordが5文字の場合" do
        let(:password) {"12345"}
        let(:password_confirmation) {"12345"}
        it {is_expected.to include("は6文字以上で入力してください")}
      end
    end
  end

  describe "userレコード削除時に子レコードの一括削削除" do
    let(:user) {FactoryBot.create(:user, :with_likes, :with_practices)}
    let(:user2) {FactoryBot.create(:ricky, :with_likes, :with_practices)}
    subject{->{user.destroy}}
    context "アソシエーション関係にあるレコードは削除される" do
      it {is_expected.to change{user.likes.length}.by(-10)}
      it {is_expected.to change{user.practices.length}.by(-10)}
    end
    context "アソシエーション関係にないレコードは削除されない" do
      it {is_expected.to change{user2.likes.length}.by(0)}
      it {is_expected.to change{user2.practices.length}.by(0)}
    end
  end
end
