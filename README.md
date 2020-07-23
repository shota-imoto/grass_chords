# アプリ概要

[GrassChords](https://grasschords.com "GrassChords")
※スマートフォンでの閲覧推奨

"Bluegrass"という音楽の「初心者向けジャムセッション支援アプリ」 です。
ジャムセッションとは、「みんなが知っている定番曲」をその場にいる人で即興で演奏することです。

このサービスでは

- 定番曲のコード譜面(曲で使われる音階がわかる譜面)を作成・共有
- 曲の難度や人気度合いを測定・表示
  することでジャム曲の練習から参加までをサポートします。

■ テストユーザーログインも可能ですので、自由にお試しください

# 機能

- コード譜面の作成・編集・削除 機能
- コード譜面エディター機能
- コード譜面の閲覧機能(音楽記号対応済み)
- コード譜のキー(※)切替機能
- 楽曲の属性表示機能(初心者向け曲など)
- 楽曲の条件検索機能: キーワード + 属性検索(ajax 対応)
- コード譜の信頼度評価ボタン(ajax)
- コード譜の練習していることの表明ボタン(ajax)
- コード譜の信頼度順ソート機能
- 楽曲の練習人数ソート機能
- ユーザ登録・ログイン機能
- ユーザ情報 編集機能
- ユーザ認証機能
- マイページ 練習曲の管理機能
- テストユーザログイン機能
- レスポンシブ対応(モバイルファースト)
- グローバルメニュー(ハンバーガーメニュー)
- グローバルサーチ
- エラーハンドリング
- モデル単体テスト(rspec)
- CSS の flocss 対応
- AWS VPC, EC2, ELB, ACM(Web サーバ 1 台＋ DB サーバ 1 台)

※音楽用語。曲全体の音の高さのこと(日本語呼称:ハ長調やト短調)
女声であれば楽曲全体の音程(=キー)を高く引き上げて演奏することがある。
キーの変更に合わせて変化するコード進行を譜面表示に反映する

# 使用技術・言語

- フロントエンド(javascript, jQuery, HTML/CSS, HAML, SASS)
- バックエンド(Ruby on Rails)
- インフラ(MySQL, nginx, unicorn)
- テスト(RSpec, FactoryBot)
- AWS EC2(Web サーバ 1 台, DB サーバ 1 台)

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
- 一曲練習するのに時間がかかる上に、「初心者同士だと全く別の曲しか弾けなかった」といったことが多い。

### どう解決するのか？

- コード進行の把握 => コード譜を蓄積・共有することで解決
- 練習曲の選定 => 練習している人の人数を集計したり、初心者向けなど属性表示することでサポート

# 実装を検討中の機能

- コード表の PDF 出力機能
- 練習しているユーザの表示機能
- youtube、Spotify などの参考リンク登録機能
- 流行り曲の集計表示機能

![jamsession](https://user-images.githubusercontent.com/62494531/87237476-b0fc7c80-c431-11ea-801e-322d550cc0f3.jpg)

# table_setting

## song

### table

| name         | type    | option      |
| ------------ | ------- | ----------- |
| title        | string  | null: false |
| jam          | boolean | null: false |
| standard     | boolean | null: false |
| beginner     | boolean | null: false |
| vocal        | boolean | null: false |
| instrumental | boolean | null: false |
| user_id      | integer | null: false |

### association

- has_many :chords, dependent: :destroy
- has_many :practices, dependent: :destroy
- has_many :keys, dependent: :destroy
- has_many :scores, dependent: :destroy
- belongs_to :user

## practice

### table

| name     | type    | option                   |
| -------- | ------- | ------------------------ |
| chord_id | integer | null: false, foreign_key |
| user_id  | integer | null: false, foreign_key |

### asocciation

- belongs_to :chord, counter_cache: true
- belongs_to :user

## chord

### table

| name           | type    | option                         |
| -------------- | ------- | ------------------------------ |
| song_id        | integer | null: false, foreign_key: true |
| user_id        | integer | foreign_key: true              |
| version        | string  |                                |
| like_count     | integer | null: false                    |
| practice_count | integer | null:false                     |

### asocciation

- belongs_to :song
- belongs_to :user
- has_many :chordunits, dependent: :destroy
- accepts_nested_attributes_for :chordunits
- has_many :likes, dependent: :destroy
- has_many :practices, dependent: :destroy
- has_many :chordunit

## chordunit

### table

| name     | type    | option      |
| -------- | ------- | ----------- |
| address  | integer | null: false |
| text     | text    |             |
| leftbar  | string  |             |
| rightbar | string  |             |
| beat     | string  |             |
| chord_id | integer | foreign_key |

### asocciation

- belongs_to :chord

## user

### table

| name                  | type   | option                    |
| --------------------- | ------ | ------------------------- |
| name                  | string | null: false, unique: true |
| email                 | string | null: false, unique: true |
| password              | text   | null: false, unique: true |
| password_confirmaiton | text   | null: false, unique: true |
| place                 | string |                           |

### asocciation

- has_many :chords
- has_many :likes, dependent: :destroy
- has_many :practices, dependent: :destroy
- has_many :instruments, through: :user_instruments
- has_many :user_instruments
- has_many :tuning_alls
- has_many :finger_alls

## like

### table

| name     | type    | option                         |
| -------- | ------- | ------------------------------ |
| chord_id | integer | null: false, foreign_key: true |
| user_id  | integer | null: false, foreign_key: true |

### asocciation

- belongs_to :chord, counter_cache: true
- belongs_to :user

---

# authority

| function                  | administrator | editor | general | guest |
| ------------------------- | ------------- | ------ | ------- | ----- |
| make/delete a protection  | o             | o      | x       | x     |
| delete records other user | o             | o      | x       | x     |
| make records              | o             | o      | o       | x     |
| delete records self made  | o             | o      | o       | x     |
| login                     | x             | x      | x       | o     |
| user registration         | x             | x      | x       | o     |
| logout                    | o             | o      | o       | x     |
| edit account              | o             | o      | o       | x     |
| make a pdf                | o             | o      | o       | o     |

# main menu

| menu                | guest_mode | user_mode | editor_mode |
| ------------------- | ---------- | --------- | ----------- |
| registration        | o          | x         | x           |
| login               | o          | x         | x           |
| my_page             | x          | o         | o           |
| practice_list       | x          | o         | o           |
| make a pdf          | o          | o         | o           |
| create - song       | x          | o         | o           |
| create - chord      | x          | o         | o           |
| create - finger     | x          | o         | o           |
| create - instrument | x          | x         | o           |
| search - score      | o          | o         | o           |
| create - score      | x          | o         | o           |
| contact             | o          | o         | o           |
| logout              | x          | o         | o           |

# routing

- song
  index, new, create, edit, show, update, destroy
- chord
  index, new, create, edit, show, update, destroy
- user
  new, create, edit, show, update, destroy
- practice
  index, create, update, destroy
