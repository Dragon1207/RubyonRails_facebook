require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @alice = users(:alice)
    @bob   = users(:bob)
    @carl  = users(:carl)
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
    assert_equal 1, @bob.friend_offers.count
    assert_equal 2, @carl.friend_offers.count
  end

  test "should be able to follow relations" do
    assert_equal @carl, @bob.friend_requests.first.requestee
  end
end
