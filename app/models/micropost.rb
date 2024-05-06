class Micropost < ApplicationRecord
  belong_to :user
  validates :user_id, presence: true
end
