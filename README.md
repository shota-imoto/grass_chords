# table_setting

## song

### table

| name     | type    | option      |
| -------- | ------- | ----------- |
| title    | string  | null: false |
| jam      | boolean | null: false |
| standard | boolean | null: false |
| beginner | boolean | null: false |
| user_id  | integer | null: false |

### association

- has_many :chords, dependent: :destroy
- has_many :practices, dependent: :destroy
- has_many :keys, , dependent: :destroy
- has_many :scores, dependent: :destroy
- belongs_to :user

## key

### table

| name         | type    | option                         |
| ------------ | ------- | ------------------------------ |
| name         | binary  | null: false                    |
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

| name         | type    | option                   |
| ------------ | ------- | ------------------------ |
| song_id      | integer | null: false, foreign_key |
| user_id      | integer | null: false, foreign_key |
| practice_key | integer |                          |

### asocciation

- belongs_to :song
- belongs_to :user

## chord

### table

| name      | type    | option                         |
| --------- | ------- | ------------------------------ |
| song_id   | integer | null: false, foreign_key: true |
| artist_id | integer | foreign_key: true              |
| album_id  | integer | foreign_key: true              |
| text      | text    | null: false, unique: true      |

### asocciation

- belongs_to :song
- belongs_to :user
- belongs_to :artist
- belongs_to :album
- has_many :likes, dependent: :destroy

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
| mail                  | string | null: false, unique: true |
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

- belongs_to :chord
- belongs_to :user

## instrument

### table

| name          | type    | option                    |
| ------------- | ------- | ------------------------- |
| name          | string  | null: false, unique: true |
| total_strings | integer | null: false               |

### asocciation

- has_many :finger_alls, dependent: :destroy
- has_many :tuning_alls, dependent: :destroy
- has_many :users, through: :user_instruments
- has_many :user_instruments

## user_instruments

### table

| name            | type    | option                         |
| --------------- | ------- | ------------------------------ |
| user_id         | integer | null: false, foreign_key: true |
| instrumental_id | integer | null: false, foreign_key: true |
| default_inst    | integer |                                |

### asocciation

- belongs_to :user
- belongs_to :instrument

## finger_all

### table

| name            | type    | option                         |
| --------------- | ------- | ------------------------------ |
| name            | string  | null: false                    |
| instrumental_id | integer | null: false, foreign_key: true |
| tuning_all_id   | integer | null: false, foreign_key: true |

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

| name            | type    | option                         |
| --------------- | ------- | ------------------------------ |
| name            | string  | null: false                    |
| instrumental_id | integer | null: false, foreign_key: true |

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
