require 'test_helper'

class FriendshipRequestsTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def setup
    @alice = users(:alice)
    sign_in @alice
  end

  ## Find (new) friends

  test "should see eric in 'friend finder' (/users); shouldn't see bob; shouldn't see alice" do
    get users_path
    assert_response :success
    assert_match "Eric", response.body
    assert_no_match "Bob", response.body
    assert_no_match "Alice", response.body
  end

  test "should have buttons to send request" do
    get users_path
    assert_select "form[action=?][method='post']", friend_requests_path
  end

  ## Sent/received friend requests

  test "should see Dave in request offers (received friend requests)" do
    get friend_requests_path
    assert_response :success
    assert_match "Dave", response.body
  end

  test "should see Bob and Carl in sent friend requests" do
    get friend_requests_path
    assert_match "Bob", response.body
    assert_match "Carl", response.body
  end
end
