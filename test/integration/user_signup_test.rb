require 'test_helper'

class UserSignupTest < ActionDispatch::IntegrationTest
  test "sign up page should exist" do
    get new_user_registration_path
    assert_response :success
  end

  test "sign up page should contain the right fields" do
    get new_user_registration_path
    assert_select "input[type=text][name='user[name]']"
    assert_select "input[type=email][name='user[email]']"
    assert_select "input[type=password][name='user[password]']"
    assert_select "input[type=password][name='user[password_confirmation]']"
  end

  test "sign up should add user in database" do
    assert_difference "User.count", 1 do
      post user_registration_path, params:{ user: { name: "Test",
                                                        email: "test@test.tes",
                                                        password: "password",
                                                        password_confirmation: "password"
                                                      }
                                              }
    end
  end
end
