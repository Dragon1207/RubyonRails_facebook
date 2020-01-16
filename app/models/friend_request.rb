class FriendRequest < ApplicationRecord
  belongs_to :requester, class_name: "User"
  belongs_to :requestee, class_name: "User"

  scope :pending,   -> { where(accepted: false) }
  scope :accepted,  -> { where(accepted: true) }
  scope :other_user_id, -> (user_id)  { select("CASE WHEN requestee_id = #{user_id} THEN requester_id WHEN requester_id = #{user_id} THEN requestee_id END AS user_id")
                                      .where("requestee_id = #{user_id} OR requester_id = #{user_id}") }
end
