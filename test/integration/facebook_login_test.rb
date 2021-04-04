require 'test_helper'

class FacebookLoginTest < ActionDispatch::IntegrationTest
  def setup
    OmniAuth.config.test_mode = true
    OmniAuth.config.mock_auth[:facebook] = nil
  end

  test "can sign up with facebook" do
    # mock data
    OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new({
      provider: 'facebook',
      uid: '123545',
      info: {
        name: 'John Smith',
        email: 'johnsmith@example.org'
      }
    })

    assert_difference 'User.count', 1 do
      post user_facebook_omniauth_authorize_path

      assert_response :redirect
      assert_redirected_to user_facebook_omniauth_callback_path
  
      follow_redirect!
      assert_response :redirect
      assert_match "Successfully authenticated", flash[:notice]
      assert_redirected_to user_path(User.find_by(uid: '123545'))

      follow_redirect!      
    end 
  end

  test "can log in with facebook" do
    # mock data
    auth_hash = OmniAuth::AuthHash.new({
      provider: 'facebook',
      uid: '123547',
      info: {
        name: 'John Jones',
        email: 'johnjones@example.org'
      }
    })
    OmniAuth.config.mock_auth[:facebook] = auth_hash

    # add user (as if he's has already signed up once)
    user = User.from_omniauth(auth_hash)

    assert_no_difference 'User.count' do
      post user_facebook_omniauth_authorize_path

      assert_response :redirect
      assert_redirected_to user_facebook_omniauth_callback_path
  
      follow_redirect!
      assert_response :redirect
      assert_match "Successfully authenticated", flash[:notice]
      assert_redirected_to user_path(user)

      follow_redirect!      
    end
  end

  test "user is not signed up, when user choses not to share email" do
    # mock data
    auth_hash = OmniAuth::AuthHash.new({
      provider: 'facebook',
      uid: '123547',
      info: {
        name: 'John Jones'
      }
    })

    assert_no_difference 'User.count' do
      post user_facebook_omniauth_authorize_path

      assert_response :redirect
      assert_redirected_to user_facebook_omniauth_callback_path
      follow_redirect!

      assert_match "Could not authenticate you", flash[:notice]
      assert_redirected_to cancel_user_registration_path
      follow_redirect!
    end
  end
end
