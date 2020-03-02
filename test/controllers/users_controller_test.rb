require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
    include Devise::Test::IntegrationHelpers

    def setup
        sign_in users(:bob)
    end

    test "friend suggestion page" do
        get users_path
        assert_response :success
    end

    test "user profile page" do
        get user_path(users(:alice))
        assert_response :success
    end

end
