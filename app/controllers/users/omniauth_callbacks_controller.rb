class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    @user = User.from_omniauth(request.env["omniauth.auth"])

    if @user.persisted?
      sign_in @user, event: :authentication
      set_flash_message(:notice, :success, kind: "Facebook") if is_navigational_format?
      redirect_to user_path(@user)
    else
      if request.env['omniauth.auth'].info.email.blank?
        unless (session["devise.email_ask_count"] ||= 1) > 3  # email ask counter; ask 3 times
          session["devise.email_ask_count"] += 1
          redirect_to user_facebook_omniauth_authorize_path(auth_type: 'rerequest', scope: 'email')
        else
          set_flash_message(:notice, :failure, kind: "Facebook", reason: 'no email given') 
          redirect_to cancel_user_registration_path
        end
      end
    end
  end
  
  def failure
    flash[:error] = "Womp womp"
    redirect_to root_path
  end
end