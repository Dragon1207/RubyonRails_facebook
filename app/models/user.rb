class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, presence: true

  # Active record relations
  has_many :friend_requests,  foreign_key: :requester_id
  has_many :friend_offers, class_name: "FriendRequest", foreign_key: :requestee_id

  has_many :friendships_made, -> { where accepted: true }, class_name: "FriendRequest",
                                                           foreign_key: :requester_id
  has_many :friendships_approved, -> { where accepted: true }, class_name: "FriendRequest",
                                                               foreign_key: :requestee_id
  has_many :friends_made, through: :friendships_made, source: :requestee
  has_many :friends_approved, through: :friendships_approved, source: :requester

  # user's friends
  def friends
    User.where(id: friendships_made.pluck(:requestee_id) + friendships_approved.pluck(:requester_id))
  end
end
