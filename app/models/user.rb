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

  has_many :posts, foreign_key: 'author_id'

  # user's friends
  def friends
    User.where("id IN (?)", friend_ids)
  end

  # user's friend recommendations
  def strangers
    ids = FriendRequest.other_user_id(id)
    User.where("id NOT IN (?) AND id != (?)", ids, id)
  end

  # Post feed: posts written by User and their friends in reverse chronological order
  # Adds attributes for number of likes (like_count), is it liked by some User (user_likes)
  def post_feed
    Post.where("author_id IN (:friends_ids) OR author_id = :user_id", friends_ids: friend_ids, user_id: id)
      .add_like_count
      .select("COUNT(ul.user_id) AS user_likes")
      .joins("LEFT JOIN likes ul ON ul.post_id=posts.id AND ul.user_id=#{id}")
      .order(created_at: :DESC)
      .includes(:author)
  end

  private

    def friend_ids
      FriendRequest.accepted.other_user_id(id)
    end      
end
