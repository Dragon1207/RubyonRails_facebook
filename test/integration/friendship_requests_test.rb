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

  test "send button should create a new request" do
    get users_path
    eric = users(:eric)
    assert_difference "@alice.friend_requests.count", 1 do
      assert_difference "eric.friend_offers.count", 1 do
        post friend_requests_path, params: { friend_id: eric.id }
      end
    end
    assert_redirected_to users_path
    follow_redirect!
    assert_no_match "Eric", response.body # removed from suggestions
  end

  ## Sent/received friend requests

  test "should see Fred in request offers (received friend requests); shouldn't see Dave" do
    get friend_requests_path
    assert_response :success
    assert_match "Fred", response.body
    assert_no_match "Dave", response.body
  end

  test "should see Bob and Carl in sent friend requests" do
    get friend_requests_path
    assert_match "Bob", response.body
    assert_match "Carl", response.body
  end

  test "should have buttons to accept and delete requests" do
    get friend_requests_path
    # fred's request to alice
    fred_to_alice = friend_requests(:six)
    assert_select "form[action=?][method='post']", friend_request_path(fred_to_alice)
    assert_select "form[action=?][method='post'] input[type=hidden][name=_method][value=patch]", friend_request_path(fred_to_alice)
    assert_select "a[href=?]", friend_request_path(fred_to_alice), "Delete Request" # delete link
  end

  test "should have buttons to revoke requests" do
    get friend_requests_path
    # alice's request to bob
    alice_to_bob = friend_requests(:one)
    assert_select "a[href=?]", friend_request_path(alice_to_bob), "Revoke Request" # revoke link
  end
end
