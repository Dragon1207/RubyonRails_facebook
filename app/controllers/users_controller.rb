class UsersController < ApplicationController
  def index
    @users = current_user.strangers
  end

  def show
    @user = User.find(params[:id])
    unless @user == current_user
      @request = FriendRequest.find_by(requester: @user, requestee: current_user) || FriendRequest.find_by(requester: current_user, requestee: @user)
    end
    @posts = @user.own_posts
  end
end
