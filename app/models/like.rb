class Like < ApplicationRecord
  belongs_to :chord, counter_cache: true
  belongs_to :user
end
