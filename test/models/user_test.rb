require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "should validate attributes; empty are invalid" do
    u = User.new
    assert_not u.valid?
  end

  test "should validate correct attributes" do
    u = User.new(name: "test", email: "mail@server.com", password: "password")
    u.validate!
    assert u.valid?
  end
end
