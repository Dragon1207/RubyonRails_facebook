require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "should validate attributes; empty are invalid" do
    u = User.new
    assert_not u.valid?
  end
end
