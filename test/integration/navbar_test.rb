require 'test_helper'

class NavbarTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  include ActionView::Helpers::TextHelper

  test "show home button" do
    get root_path
    assert_select "a[href=?]", root_path, text: 'Phacepook', count: 1 # home link
  end

  test "shouldn't show navbar buttons when no user is signed in" do
    get root_path
    assert_select "a[href=?]", users_path, count: 0 # find friends link
    assert_select "a[href=?]", destroy_user_session_path, count: 0 # sign out link
  end

  test "should show navbar when a user is signed in" do
    alice = users(:alice)
    sign_in alice
    get root_path
    follow_redirect!
    assert_select "a[href=?]", root_path, text: 'Phacepook', count: 1 # home link
    assert_select "a[href=?]", users_path, count: 1 # find friends link
    assert_select "a[href=?]", destroy_user_session_path, count: 1 # sign out link
    assert_select "a[href=?]", user_path(alice), alice.name # profile link
    # friend requests notification link
    assert_select "a[href=?]", friend_requests_path,
                               "(#{alice.friend_offers.pending.count}) Friend #{"Request".pluralize(alice.friend_offers.pending.count)}"
  end
end
