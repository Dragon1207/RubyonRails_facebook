require 'test_helper'

class StaticPagesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  test "should get root" do
    get root_url
    assert_response :success
  end

  test "should redirect signed in users" do
    sign_in(users(:alice))

    get root_url
    assert_response :redirect
    assert_redirected_to posts_path
  end

  test "should get about page" do
    get about_url
    assert_response :success
  end

end
