class Relationship < ApplicationRecord
  belong_to :follower,  class_name: "User"
  belong_to :follower,  class_name: "User"
  validates :follower_id, presense: true
  validates :followed_id, presense: true
end
