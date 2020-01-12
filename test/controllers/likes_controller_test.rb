require 'test_helper'

class LikesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def setup
    @user = users(:alice)
    sign_in @user
    @post = @user.post_feed.first
  end

  test "should create like" do
    assert_difference '@post.likes.count', 1 do
      post post_likes_path(@post)
    end
  end

  test "should not create like again" do
    post post_likes_path(@post) # like once

    assert_no_difference '@post.likes.count' do
      post post_likes_path(@post) # should not have an effect
    end
  end

  test "should remove like" do
    post post_likes_path(@post) # like once

    assert_difference '@post.likes.count', -1 do
      delete post_like_path(@post, 0) # remove like
    end
  end
end
