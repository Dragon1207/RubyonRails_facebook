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
end
