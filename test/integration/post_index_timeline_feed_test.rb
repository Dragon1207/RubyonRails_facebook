require 'test_helper'

class PostIndexTimelineFeedTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def setup
    @alice = users(:alice)
  end 

  test "post index page" do
    ## should redirect when not signed in
    get posts_path
    assert_response :redirect
    assert_redirected_to new_user_session_url
    follow_redirect!

    sign_in @alice

    get posts_path
    assert_response :success

    ## should display feed
    assert_select '.post-display'
    assert_select '.post-content'
    feed = @alice.post_feed.limit(10)
    feed.each do |post|
      assert_match CGI::escapeHTML(post.author.name), response.body
      assert_match CGI::escapeHTML(post.text), response.body

      # should display comments
      post.comments.each do |comment|
        assert_match CGI::escapeHTML(comment.author.name), response.body
        assert_match CGI::escapeHTML(comment.text), response.body
      end
    end
    # and like button and comment button
    assert_select '.post-buttons > form'
  end
end
