class Comment < ApplicationRecord
  belongs_to :post
  belongs_to :author, class_name: "User"

  default_scope -> { order(created_at: :asc) }

  validates :text, presence: true
end
