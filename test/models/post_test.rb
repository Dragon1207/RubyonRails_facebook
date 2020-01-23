require 'test_helper'

class PostTest < ActiveSupport::TestCase
  test "posts should have author and text" do
    post = Post.new
    assert_not post.valid?

    post = Post.new author_id: users(:alice).id, text: "Test test test"
    assert post.valid?
  end

  test "author should link to user" do
    assert_equal users(:alice), posts(:first_post).author
  end

  ## Likes

  test "should have likes" do
    assert_not_nil posts(:first_post).likes
  end

  test "should remove likes on destroy" do
    post = users(:alice).posts.create(text: "Temp post")
    post.likes.create(user: users(:bob))

    assert_difference "Post.count", -1 do
      assert_difference "Like.count", -1 do
        post.destroy
      end
    end
  end

  ## Comments

  test "should have comments" do
    assert_not_nil posts(:first_post).comments
    assert posts(:first_post).comments.include?(comments(:one))
    assert posts(:first_post).comments.include?(comments(:two))
  end

  test "should remove comments when deleted" do
    post = users(:alice).posts.create(text: "Temp post")

    post.comments.create(author: users(:bob), text: "Nice post!")
    post.comments.create(author: users(:bob), text: "Well done! (y)")

    assert_difference 'Comment.count', -2 do
      post.destroy
    end
  end
end
