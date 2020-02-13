require 'test_helper'
require 'faker'

class UserTest < ActiveSupport::TestCase
  def setup
    @alice = users(:alice)
    @bob   = users(:bob)
    @carl  = users(:carl)
    @dave  = users(:dave)

    @feed = @alice.post_feed
  end

  test "should validate attributes; empty are invalid" do
    u = User.new
    assert_not u.valid?
  end

  test "should validate correct attributes" do
    u = User.new(name: "test", email: "mail@server.com", password: "password")
    u.validate!
    assert u.valid?
  end

  test "should have friend request" do
    assert_equal 2, @alice.friend_requests.count
    assert_equal 0, @carl.friend_requests.count
  end

  test "should have friend offers" do
    assert_equal 2, @bob.friend_offers.count
    assert_equal 2, @carl.friend_offers.count
  end

  test "should be able to follow relations" do
    assert_equal @carl, @bob.friend_requests.first.requestee
  end

  ## Friendship associations

  test "friendships_made are accepted friend requests" do
    assert_equal 1, @alice.friendships_made.count
    assert_equal 2, @dave.friendships_made.count
    assert_equal 0, @bob.friendships_made.count
  end

  test "friendships_approved are accepted friend offers" do
    assert_equal 1, @alice.friendships_approved.count
    assert_equal 0, @dave.friendships_approved.count
  end

  ## Friends associations

  test "friends_made are friends from made friendships" do
    assert_equal 1, @alice.friends_made.count
    assert_equal @carl, @alice.friends_made.first

    assert_equal 2, @dave.friends_made.count
  end

  test "friends approved are friends from approved friendships" do
    assert_equal 1, @alice.friends_approved.count
    assert_equal @dave, @alice.friends_approved.first

    assert_equal 1, @carl.friends_approved.count
    assert_equal @alice, @carl.friends_approved.first
  end

  ## Friends collection

  test "friends returns ActiveRecord relation of friends" do
    assert_equal 2, @alice.friends.count
  end

  ## Strangers
  test "should not contain Bob and Alice" do
    assert_not @alice.strangers.include?(@bob)
    assert_not @alice.strangers.include?(@alice)
  end

  ## Post feed

  test "should get post feed" do
    assert_not_nil @alice.post_feed
    assert_not_nil @bob.post_feed
    assert_not_nil @carl.post_feed
    assert_not_nil @dave.post_feed
  end

  test "should have like count in feed" do
    @feed.each { |post| assert_not_nil post.like_count }
  end

  test "should have comments in feed" do
    @feed.each { |post| assert_not_nil post.comments }
  end

  ## Written comments

  test "should be able to get to comments" do
    comms = @carl.comments.map(&:text)
    assert comms.include?("Carl's comment on Alice's post")
  end

  test "should remove comments when deleted" do
    user = User.create!(name: Faker::Name.name, email: Faker::Internet.email, password: Faker::Internet.password)
    posts(:first_post).comments.create(author: user, text: "soon to be removed")
    assert_difference 'Comment.count', -1 do
      user.destroy
    end
  end
end
