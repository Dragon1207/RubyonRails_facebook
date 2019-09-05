class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, presence: true

  # Active record relations
  has_many :friend_requests,  foreign_key: :requester_id
  has_many :friend_offers, class_name: "FriendRequest", foreign_key: :requestee_id
end
