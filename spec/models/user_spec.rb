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
          FactoryBot.create(:user, name: "Jim Mills")
          user.valid?
        end
        it {is_expected.to include("は既に登録されています")}
      end
    end
  end

  # リファクタリングが必要
  describe "user登録時のバリデーションチェック" do
    context "emailの値が登録されるとき" do
      it "emailの文字数が3文字の場合は登録されること" do
        user = FactoryBot.build(:user, email: "b@b")
        expect(user).to be_valid
      end
      it "emailの文字数が254文字の場合は登録されること" do
        user = FactoryBot.build(:user, email: "ydih7aTzftql6KoW0hZKzvO9KMf82CkbvAKmjSUAeGnchnt98XRk1QL9TazFIxfL4wxJvrvkchhJDPaAzVcg5dCKK8L8YSQIELop@vcctPBLh3Ys8LZ1zBPRLm7BNCx7rU5okBFhuXg3QkKRWBE9i0AUk8TCIGANOrG9MBxmOB7ygOVj60BgvcdMDKuM64QdKuffnKPGrXDDvzQVfBgWKrQJNRBCfqt3GqrINpp3sXY7ezJ4OoB7EOTkjROry6")
        expect(user).to be_valid
      end
    end

    context "emailの値が登録されないとき" do
      it "emailがない場合は登録されないこと" do
        user = FactoryBot.build(:user, email: nil)
        user.valid?
        expect(user.errors[:email]).to include("を入力してください")
      end
      it "すでに登録されているemailの場合は登録されないこと" do
        FactoryBot.create(:user, email: "bound_ride@bluegrass.com")
        user = FactoryBot.build(:ricky, email: "bound_ride@bluegrass.com")
        user.valid?
        expect(user.errors[:email]).to include("は既に登録されています")
      end
      it "すでに登録されているemailの最初の1文字を大文字に変えた場合でも登録されないこと" do
        FactoryBot.create(:user, email: "bound_ride@bluegrass.com")
        user = FactoryBot.build(:ricky, email: "Bound_ride@bluegrass.com")
        user.valid?
        expect(user.errors[:email]).to include("は既に登録されています")
      end
      it "emailの文字数が2文字の場合は登録されないこと" do
        user = FactoryBot.build(:user, email: "b@")
        user.valid?
        expect(user.errors[:email]).to include("は254文字以内のものを登録してください")
      end
      it "emailの文字数が255文字の場合は登録されないこと" do
        user = FactoryBot.build(:user, email: "RB9thr2On5XIihPibexjIDilMsY1iNuHQEswR73Oml3MHEIpnt3GNogzjbpTt7a0yjNQTo9QmeXjRurXtxysAB8gJIdufMmeuw0jaMh@3IEdy2Qs0xsX9wbuZssRgriJgVniAmXL4GtAdwrs4VtKqLnkSznbZSiwGmKRGE3jIrdefNQKt6w6CLY1RDSkAm77OBKAVrlIM9fb6EaEpKh4e3zn3aCQFbi4ePttqWpnHvDQ7s65nM8uYNE9wnwgFOd")
        user.valid?
        expect(user.errors[:email]).to include("は254文字以内のものを登録してください")
      end
    end

    context "adminの値が登録されるとき" do
      it "adminの値が空欄の場合は登録されること" do
        user = FactoryBot.build(:user, admin: "")
        expect(user).to be_valid
      end
      it "adminの値がfalseの場合は登録されること" do
        user = FactoryBot.build(:user, admin: false)
        expect(user).to be_valid
      end
    end

    context "adminの値が登録されないとき" do
      it "adminの値がtrueの場合は登録されないこと" do
        user = FactoryBot.build(:user, admin: true)
        user.valid?
        expect(user.errors[:admin]).to include("システムエラー：不正な値が入力されました")
      end
    end

    context "placeの値が登録されるとき" do
      it "placeがない場合でも登録されること" do
        user = FactoryBot.build(:user, place: "")
        expect(user).to be_valid
      end
      it "placeの値が50文字の場合は登録されること" do
        user = FactoryBot.build(:user, place: "ゅがゕゆすほじぇなむゆぴぃゅぉろはえぉやっみぉちらぎはぇかぢぉはふしすちだへぷぜさだえゖてにだじもが")
        user.valid?
        expect(user).to be_valid
      end
    end

    context "placeの値が登録されないとき" do
      it "placeの値が51文字の場合は登録されないこと" do
        user = FactoryBot.build(:user, place: "ゅがゕゆすほじぇなむゆぴぃゅぉろはえぉやっみぉちらぎはぇかぢぉはふしすちだへぷぜさだえゖてにだじもがあ")
        user.valid?
        expect(user.errors[:place]).to include("は50文字以内に設定してください")
      end
    end

    context "passwordの値が登録されるとき" do
      it "passwordが6文字のときは登録されること" do
        user = FactoryBot.build(:user, password: "123456")
        expect(user).to be_valid
      end
    end

    context "passwordの値が登録されないとき" do
      it "passwordがない場合は登録されないこと" do
        user = FactoryBot.build(:user, password: nil)
        user.valid?
        expect(user.errors[:password]).to include("を入力してください")
      end
      it "passwordが存在してもpassword_confirmationがない場合は登録されないこと" do
        user = FactoryBot.build(:user, password: "123456", password_confirmation: "654321")
        user.valid?
        expect(user.errors[:password_confirmation]).to include("とパスワードの入力が一致しません")
      end
      it "passwordが5文字のときは登録されないこと" do
        user = FactoryBot.build(:user, password:"12345")
        user.valid?
        expect(user.errors[:password]).to include("は6文字以上で入力してください")
      end
    end
  end
  describe "userレコード削除時に子レコードの一括削除動作のチェック" do
    context "userレコード削除時に、アソシエーション関係にあるレコードが削除されること" do
      it "userレコード削除時に、アソシエーション関係にあるlikeレコードがすべて削除されること"
      it "userレコード削除時に、アソシエーション関係にあるpractieレコードがすべて削除されること"
    end

    context "userレコード削除時に、アソシエーション関係にないレコードは削除されないこと" do
      it "userレコード削除時に、アソシエーション関係にないlikeレコードは削除されないこと"
      it "userレコード削除時に、アソシエーション関係にないpracticeレコードは削除されないこと"
    end
  end
end
