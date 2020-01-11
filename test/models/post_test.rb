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
end
