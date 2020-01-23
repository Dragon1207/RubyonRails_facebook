require 'test_helper'

class CommentTest < ActiveSupport::TestCase
  test "shouldn't accept empty text" do
    com = Comment.new(author: users(:alice),
                        post: posts(:first_post))
    assert_not com.valid?
  end

  test "shouldn't accept missing author or post" do
    com = Comment.new(post: posts(:first_post),
                        text: "Something")
    assert_not com.valid?

    com = Comment.new(author: users(:alice),
                        text: "Something")
    assert_not com.valid?
  end

  test "should have relations to author and post" do
    assert_equal users(:carl), comments(:one).author
    assert_equal posts(:first_post), comments(:one).post
    assert_equal users(:alice), comments(:one).post.author # multiple models
  end
end
