class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    @user = User.from_omniauth(request.env["omniauth.auth"])

    if @user.persisted?
      sign_in @user, event: :authentication
      set_flash_message(:notice, :success, kind: "Facebook") if is_navigational_format?
      redirect_to user_path(@user)
    else
      if request.env['omniauth.auth'].info.email.blank?
        set_flash_message(:notice, :failure, kind: "Facebook", reason: 'no email given') 
        redirect_to cancel_user_registration_path
      end
    end
  end
  
  def failure
    flash[:error] = "Womp womp"
    redirect_to root_path
  end
end