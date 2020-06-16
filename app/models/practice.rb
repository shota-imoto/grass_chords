class Practice < ApplicationRecord
  belongs_to :user
  belongs_to :chord, counter_cache: true
end
