class Post < ApplicationRecord
  belongs_to :author, class_name: "User"

  validates :text, presence: true

  has_many :likes, dependent: :destroy
  has_many :comments, dependent: :destroy
end
