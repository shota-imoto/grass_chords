# アプリ概要

Bluegrass という音楽の「初心者向けジャムセッション支援アプリ」 です。
ジャムセッションとは、「みんなが知っている定番曲」をその場にいる人で即興で演奏することです。
このサービスでは定番曲のコード譜面(曲で使われる音階がわかる譜面)を作成・共有したり、曲の難度や人気度合いを測定・表示することでジャム曲の練習から参加までをサポートします。

※解決したい課題については後述

# 機能

- コード譜面の作成・編集・削除 機能: 譜面エディター付き
- コード譜面の閲覧機能: 音楽理論に則ったキー※の切替え機能
- 定番曲の検索機能: キーワード + 初心者向け等の属性検索
- ユーザ認証機能
- いいね機能（練習している意思表明、コード譜の信頼度の評価ボタン）
- 楽曲ごとに練習している人数の集計機能
- グローバルメニュー(ハンバーガーメニュー)

※音楽用語。曲全体の音の高さのこと(日本語呼称:ハ長調やト短調)
女声であれば楽曲全体の音程(=キー)を高く引き上げて演奏することがある。
キーを変更すると、コードの進行も変わるが、初心者が即座に判断して演奏することは困難。

# 使用技術・言語

- フロントエンド(javascript, jQuery)
- バックエンド(Ruby on Rails)
- インフラ(MySQL, nginx, unicorn)
- AWS EC2(Web サーバ 1 台, DB サーバ 1 台)

# このアプリで解決したい課題

ジャムセッションからは音楽を楽しむ上で、非常に重要だが、音楽初心者にとっては参加のハードルが高い。
→ 以下、詳細

ジャムセッションに参加していくことで得られるメリットは次のとおりです

0. 楽しさ(Bluegrass 音楽の醍醐味)
1. 上達速度の向上(合奏する経験の蓄積が加速)
2. 音楽仲間どうし、すぐ仲良くなれる(コミュニケーションが促進)

音楽初心者こそ参加すべきだが、ハードルが高いのも事実。

- 曲を練習するために必要なコード進行(曲で使われている音の流れ)の把握が困難
- 一曲練習するのに時間がかかる上に、「初心者同士だと全く別の曲しか弾けなかった」といったことが多い。

→ これらの課題を解決するサービスが、このアプリです。

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

## key

### table

| name         | type    | option                         |
| ------------ | ------- | ------------------------------ |
| name         | integer | null: false                    |
| instrumental | boolean | null: false                    |
| male         | boolean | null: false                    |
| female       | boolean | null: false                    |
| song_id      | integer | null: false, foreign_key: true |

### asocciation

- belongs_to :song

## score

### table

| name      | type    | option                         |
| --------- | ------- | ------------------------------ |
| image     | text    | null: false, unique: true      |
| song_id   | integer | null: false, foreign_key: true |
| chord_num | integer | null: false                    |

### asocciation

- belongs_to :song

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

## artist

### table

| name | type   | option                    |
| ---- | ------ | ------------------------- |
| name | string | null: false, unique: true |

### association

- has_many :chords
- has_many :albums

## album

### table

| name      | type    | option            |
| --------- | ------- | ----------------- |
| name      | string  | null: false       |
| artist_id | integer | foreign_key: true |

### association

- has_many :chords
- belongs_to :artist

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

## instrument

### table

| name         | type    | option                    |
| ------------ | ------- | ------------------------- |
| name         | string  | null: false, unique: true |
| total_string | integer | null: false               |

### asocciation

- has_many :finger_alls, dependent: :destroy
- has_many :tuning_alls, dependent: :destroy
- has_many :users, through: :user_instruments
- has_many :user_instruments

## user_instrument

### table

| name          | type    | option                         |
| ------------- | ------- | ------------------------------ |
| user_id       | integer | null: false, foreign_key: true |
| instrument_id | integer | null: false, foreign_key: true |
| default_inst  | integer |                                |

### asocciation

- belongs_to :user
- belongs_to :instrument

## finger_all

### table

| name          | type    | option                         |
| ------------- | ------- | ------------------------------ |
| name          | string  | null: false                    |
| instrument_id | integer | null: false, foreign_key: true |
| tuning_all_id | integer | null: false, foreign_key: true |

### asocciation

- belongs_to :instrument
- belongs_to :tuning_all
- has_many :fingers
- belongs_to :user

## finger

### table

| name          | type    | option                         |
| ------------- | ------- | ------------------------------ |
| string_num    | integer | null: false                    |
| fret_num      | integer | null: false                    |
| finger_all_id | integer | null: false, foreign_key: true |

### asocciation

- belongs_to :finger_all

## tuning_all

### table

| name          | type    | option                         |
| ------------- | ------- | ------------------------------ |
| name          | string  | null: false                    |
| instrument_id | integer | null: false, foreign_key: true |

### asocciation

- has_many :finger_alls
- has_many :tunings
- belongs_to :instrument
- belongs_to :user

## tuning

### table

| name         | type    | option                         |
| ------------ | ------- | ------------------------------ |
| string_num   | integer | null: false                    |
| note_name    | integer | null: false                    |
| tunig_all_id | integer | null: false, foreign_key: true |

### asocciation

- belongs_to :tuning_all

---

# authority

| function                  | administrator | editor | general | guest |
| ------------------------- | ------------- | ------ | ------- | ----- |
| make/delete a protection  | o             | o      | x       | x     |
| make/delete a instrument  | o             | o      | x       | x     |
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
| logout              | x          | o         | o           | - |

# routing

- song
  index, new, create, edit, show, update, destroy
- chord
  index, new, create, edit, show, update, destroy
- user
  new, create, edit, show, update, destroy
- instrument
  index, new, create, edit, update, destroy
- finger_all
  index, new, create, edit, update, destroy
- tuning_all
  index, new, create, edit, update, destroy
- score
  index, new, create, edit, show, update, destroy
- practice
  index, create, update, destroy
