class Post < ApplicationRecord
  belongs_to :author, class_name: "User"

  validates :text, presence: true

  has_many :likes, dependent: :destroy

  default_scope { select("posts.*") }

  # Adds 'like_count' attribute to posts in a relation 
  def self.add_like_count
    select("COUNT(likes.user_id) AS like_count")
      .left_outer_joins(:likes)
      .group(:id)
  end
end
