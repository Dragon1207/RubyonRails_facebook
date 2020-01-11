require 'test_helper'

class LikeTest < ActiveSupport::TestCase
  test "should link to user" do
    assert_equal likes(:one).user, users(:carl)
  end

  test "should link to post" do
    assert_equal likes(:one).post, posts(:first_post)
  end
end
