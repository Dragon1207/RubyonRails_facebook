require 'test_helper'

class FriendshipRequestsTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def setup
    @alice = users(:alice)
    sign_in @alice

    @eric = users(:eric)  # no friend req. relation
    @fred = users(:fred)  # asked alice to be friends
    @bob  = users(:bob)   # was asked by alice

    @fred_to_alice = friend_requests(:six)
    @alice_to_bob = friend_requests(:one)
  end

  ## Find (new) friends

  test "should see eric in 'friend finder' (/users); shouldn't see bob; shouldn't see alice" do
    get users_path
    assert_response :success
    assert_select "li", text: "Eric"
    assert_select "li", text: "Bob", count: 0
    assert_select "li", text: "Alice", count: 0
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
    assert_select "li", text: "Eric", count: 0 # removed from suggestions
    assert_match "Friend request sent to #{eric.name}.", response.body # flash message
  end

  ## Sent/received friend requests

  test "should see Fred in request offers (received friend requests); shouldn't see Dave" do
    get friend_requests_path
    assert_response :success
    assert_match "Fred", response.body
    assert_no_match "Dave", response.body
  end

  test "Bob is listed in sent friend requests; Carl isn't" do
    get friend_requests_path
    assert_match "Bob", response.body
    assert_no_match "Carl", response.body
  end

  test "should have buttons to accept and delete requests" do
    get friend_requests_path
    assert_select "form[action=?][method='post']", friend_request_path(@fred_to_alice)
    assert_select "form[action=?][method='post'] input[type=hidden][name=_method][value=patch]", friend_request_path(@fred_to_alice)
    assert_select "a[href=?]", friend_request_path(@fred_to_alice), "Delete Request" # delete link
  end

  test "should have buttons to revoke requests" do
    get friend_requests_path
    assert_select "a[href=?]", friend_request_path(@alice_to_bob), "Revoke Request" # revoke link
  end

  test "accepting offers should add friends, remove offers" do
    assert_difference "@alice.friends.count", 1 do
      assert_difference "@alice.friend_offers.pending.count", -1 do
        patch friend_request_path(@fred_to_alice), params: { accepted: true }
      end
    end
    assert_redirected_to friend_requests_path
    follow_redirect!
    assert_no_match "Fred", response.body
  end

  test "deleting should remove request" do
    assert_difference "FriendRequest.count", -1 do
      assert_difference "@alice.friend_offers.count", -1 do
        delete friend_request_path(@fred_to_alice)
      end
    end
    assert_redirected_to friend_requests_path
    follow_redirect!
    assert_no_match "Fred", response.body

    assert_difference "FriendRequest.count", -1 do
      assert_difference "@alice.friend_requests.count", -1 do
        delete friend_request_path(@alice_to_bob)
      end
    end
    assert_redirected_to friend_requests_path
    follow_redirect!
    assert_no_match "Bob", response.body
  end

  ## On user's profile
  test "stranger's profile has buttons to send request" do
    get user_path(@eric)
    assert_select "form[action=?][method='post']", friend_requests_path
  end

  test "requester's profile has buttons to accept and delete request" do
    get user_path(@fred)
    assert_select "form[action=?][method='post']", friend_request_path(@fred_to_alice)
    assert_select "form[action=?][method='post'] input[type=hidden][name=_method][value=patch]", friend_request_path(@fred_to_alice)
    assert_select "a[href=?]", friend_request_path(@fred_to_alice), "Delete Request" # delete link
  end

  test "requestee's profile has buttons to revoke request" do
    get user_path(@bob)
    assert_select "a[href=?]", friend_request_path(@alice_to_bob), "Revoke Request" # revoke link
  end

  ## Redirects
  test "user is redirected back to the original page: find friends page" do
    get users_path

    post friend_requests_path, params: { friend_id: @eric.id }
    assert_redirected_to users_path
    follow_redirect!
  end

  test "user is redirected to the original page: friend requests page" do
    get friend_requests_path
    
    patch friend_request_path(@fred_to_alice), params: { accepted: true }
    assert_redirected_to friend_requests_path
    follow_redirect!

    delete friend_request_path(@alice_to_bob) 
    assert_redirected_to friend_requests_path
    follow_redirect!
  end

  test "user id redirected to the original page: other user's profile page" do
    actions = { @eric => {
                  method: :post,
                  args: [friend_requests_path, {params: { friend_id: @eric.id }}]
                },
                @fred => {
                  method: :patch,
                  args: [friend_request_path(@fred_to_alice), {params: { accepted: true }}]
                },
                @bob => {
                  method: :delete,
                  args: [friend_request_path(@alice_to_bob), {}]
                }
              }
    
    actions.each do |user, action|          
      method = action[:method]
      args = action[:args]
      args[1][:headers] = {referer: user_path(user)}
      
      get user_path(user)
      send(action[:method], *args)
      assert_redirected_to user_path(user)
    end
  end
end
