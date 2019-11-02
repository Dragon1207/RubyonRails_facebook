require 'test_helper'

class PostsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def setup
    @alice = users(:alice)
    sign_in @alice
  end

  test "should get index" do
    get posts_url
    assert_response :success
  end

  test "should contain alice's post" do
    get posts_url
    assert_match posts(:first_post).text, response.body
  end

  test "should contain alice's friend's posts" do
    get posts_url
    @alice.friends.each do |friend|
        friend.posts.each do |p|
          assert_match CGI::escapeHTML(p.text), response.body
        end
    end
  end

  test "should create new post" do
    assert_difference "Post.count" do
      post posts_url, params: { post: { text: "My new post!" } }
    end
  end

end
