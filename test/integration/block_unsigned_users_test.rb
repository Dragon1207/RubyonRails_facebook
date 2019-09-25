require 'test_helper'

class BlockUnsignedUsersTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  test "should redirect un-signed-in users" do
    [friend_requests_path,
      edit_user_registration_path,
      users_path
      ].each do |path|
      get path
      assert_response :redirect
      assert_redirected_to new_user_session_path
    end
  end

  test "should not redirect un-signed-in users on home page and sign-in page" do
    [root_path,
      new_user_session_path,
      new_user_registration_path
      ].each do |path|
      get path
      assert_response :success
    end
  end

  test "should not redirect signed-in users" do
    sign_in users(:alice)
    [friend_requests_path,
      edit_user_registration_path,
      users_path
      ].each do |path|
      get path
      assert_response :success
    end
  end
end
