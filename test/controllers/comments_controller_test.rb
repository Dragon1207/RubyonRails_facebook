require 'test_helper'

class CommentsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def setup
    @user = users(:alice)
    sign_in @user
    @post = Post.take
  end

  test "should create comment" do
    assert_difference '@post.comments.count', 1 do
      post post_comments_path(@post), params: { text: "A comment :)" }
    end
    assert_response :redirect
  end

  test "should remove comment" do
    post post_comments_path(@post), params: { text: "Will delete this comment" } # add a comment

    comment = @post.comments.where(author: @user).order(created_at: :desc).first

    assert_difference '@post.comments.count', -1 do
      delete comment_path(comment) # remove comment
    end
    assert_response :redirect
  end

  test "should not be able to remove other people's comments" do
    comment = comments(:one)
    post = comment.post

    assert_no_difference 'post.comments.count' do
      delete comment_path(comment) # try to remove
    end
    assert_response :redirect
  end
end
