class FriendRequest < ApplicationRecord
  belongs_to :requester, class_name: "User"
  belongs_to :requestee, class_name: "User"

  scope :pending, lambda { where(accepted: false) }
end
