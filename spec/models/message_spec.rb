require 'rails_helper'

RSpec.describe Message, type: :model do
  describe "textのバリデーション" do
    let(:message) {FactoryBot.build(:message, text: text)}
    context "登録される" do
      subject {message}
      context "textの文字数が1文字の場合" do
        let(:text) {"あ"}
        it {is_expected.to be_valid}
      end
      context "textの文字数が150文字の場合" do
        let(:text) {"あるニワトリ小屋で、飼育員が毎日、エサを決まった時間に同じ量だけを与えていた。飼育員は、非常に几帳面な性格だったらしく、何年間も正確に同じことをしていた。さて、小屋の中のニワトリたちは、なぜ、毎日同じ時間に同じ量のエサが放り込まれるのか、その原理や仕組みをまったく想像しようもなかった。が、とにかく、"}
        it {is_expected.to be_valid}
      end
    end
    context "登録されない" do
      subject {message.errors[:text]}
      before do
        message.valid?
      end
      context "textの文字数が0文字の場合" do
        let(:text) {""}
        it {is_expected.to include("が空欄です")}
      end
      context "textの文字数が151文字の場合" do
        let(:text) {"あるニワトリ小屋で、飼育員が毎日、エサを決まった時間に同じ量だけを与えていた。飼育員は、非常に几帳面な性格だったらしく、何年間も正確に同じことをしていた。さて、小屋の中のニワトリたちは、なぜ、毎日同じ時間に同じ量のエサが放り込まれるのか、その原理や仕組みをまったく想像しようもなかった。が、とにかく、毎"}
        it {is_expected.to include("は150文字以内で入力してください")}
      end
    end
  end
end
