# アプリ概要

[GrassChords](https://grasschords.com "GrassChords")
※スマートフォン向けサイト(PC でも閲覧可能)

"Bluegrass"という音楽の「初心者向けジャムセッション支援アプリ」 です。
ジャムセッションとは、「みんなが知っている定番曲」をその場にいる人で即興で演奏することです。

このサービスでは

- 定番曲のコード譜面(曲で使われる音階がわかる譜面)を作成・共有
- 曲の難度や人気度合いを測定・表示
  することでジャム曲の練習から参加までをサポート

■ テストユーザーログインも可能ですので、自由にお試しください

# 使用技術・言語

- フロントエンド(javascript, jQuery, HTML/CSS, HAML, Sass)
- バックエンド(Ruby on Rails, 外部 API)
- テスト(RSpec, FactoryBot, Capybara)
- Web サーバ(nginx, unicorn)
- データベース(MySQL)
- コンテナ(Docker, docker-compose)
- AWS(VPC, EC2, Route53, ELB, ACM, ECS, SSM, KMS, CLI)
- 開発環境(VScode, Git, GitHub, CircleCI)

# インフラ構成

![environment](./public/images/GrassChords_Env.png)

# このアプリで解決したい課題

ジャムセッションからは音楽を楽しむ上で、非常に重要だが、音楽初心者にとっては参加のハードルが高い。

## 詳細

### ジャムセッションに参加していくことで得られるメリット

0. 楽しさ(Bluegrass 音楽の醍醐味)
1. 上達スピードの向上(合奏する経験の蓄積が加速)
2. 音楽仲間どうし、すぐ仲良くなれる(コミュニケーションが加速)

音楽初心者こそ参加すべき。
しかし、ハードルが高いのも事実。

### 高いハードルの要因

- 曲を練習するために必要なコード進行(曲で使われている音の流れ)の把握が困難
- 一曲練習するのに時間がかかる上に、「初心者同士で全く別の曲しか弾けなかった」といったことも…

### どう解決するのか？

- コード進行の把握 => コード譜を蓄積・共有することで解決
- 練習曲の選定 => 練習している人の人数を集計したり、初心者向けなど属性表示することでサポート

# 使ってみよう

## コード譜を見つけよう

- トップページの検索窓に"Country Road"と入力し、Jam アイコンをクリックしてから、検索ボタンをクリック
- 検索結果に表示された"Country Road"をクリック。コード譜が表示されます
- ジャムしながら見たいときは"拡大して見る"をクリック
- コードを鳴らしながら歌ってみて、声の高さが合わないと思ったら、"key of ○○"と表示されているボタンをクリック
- 表示されるメニューを操作してみましょう。選択したキーに合わせてコード譜の表示が変化します

## 人気曲を調べよう

- トップページの検索機能に何も入力せず、検索ボタンをクリック
- "練習してる人順"を選択後、もう一度"検索ボタンを"クリック
- 練習しているユーザが多い曲順に楽曲が表示されます

## 楽曲を登録しましょう

この曲のコード譜がないな？と思った楽曲登録しましょう！

- ユーザログインします(テストユーザログインも可能です)
- 画面右上にあるボタンからメニューを開き、"データ登録"=>"楽曲を登録"の順にクリック
- 曲名と楽曲の特徴に該当する特徴をアイコンから選択して、"登録"をクリック

## コード譜を登録しましょう

あなたが Bluegrass 上級者であれば、その知見を必要としている人がいます！

- ユーザログインします(テストユーザログインも可能です)
- 画面右上にあるボタンからメニューを開き、"データ登録"=>"コード譜"の順にクリック
- "曲名"に文字を入力すると楽曲が検索表示されます。コード譜を登録したい楽曲を選択しましょう！
- 画面右下の"Editor"ボタンをクリックすると、編集キーボードが表示されます
- コード譜を入力したいスペースをクリックすると、カーソル点滅が始まります
- カーソル点滅状態で編集キーボードをクリックすると選択箇所に入力されます
- 編集が完了したら編集キーボード右上の × ボタンをクリック
- スクロールして画面下部まで移動し、"登録"をクリック

ありがとうございます！これであなたの知見が共有されました。
検索機能で先程登録された楽曲を検索すると、登録したコード譜が確認できます。

# 機能要件

- コード譜面の作成・編集・削除 機能
- コード譜面エディター機能
- コード譜面の閲覧機能(音楽記号対応済み)
- コード譜のキー(\*)切替機能
- 楽曲の属性表示機能(初心者向け曲など)
- 楽曲の条件検索機能: キーワード + 属性検索(ajax 対応)
- コード譜の信頼度評価ボタン(ajax)
- 楽曲の練習をしていることの表明ボタン(ajax)
- コード譜の信頼度順ソート機能
- 楽曲の練習人数ソート機能
- ユーザ登録機能
- ユーザ情報 編集機能
- ユーザ認証機能
- マイページ 練習曲の管理機能
- テストユーザログイン機能
- グローバルメニュー(ハンバーガーメニュー)
- グローバルサーチ

\* 音楽用語。曲全体の音の高さのこと(日本語呼称:ハ長調やト短調)
女声であれば楽曲全体の音程(=キー)を高く引き上げて演奏することがある。
キーの変更に合わせて変化するコード進行を譜面表示に反映する

# 非機能要件

- レスポンシブ対応(モバイルファースト)
- CSS の flocss 対応
- エラーハンドリング
- ReCAPTCHA(API)を用いたセキュアなユーザ認証
- SSL 認証
- ロードバランス
- オートスケール(ECS タスク)
- ローリングアップデート
- モデル/コントローラの単体テスト(rspec)
- 統合テスト(capybara)
- CI/CD パイプライン

# 実装を検討中の機能

- コード表の PDF 出力機能
- 練習しているユーザの表示機能
- youtube、Spotify などの参考リンク登録機能
- 流行り曲の集計表示機能
