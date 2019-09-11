class FriendRequestsController < ApplicationController
  def index
    unless current_user.nil?
      @friend_offers = current_user.friend_offers
      @friend_requests = current_user.friend_requests
    else
      @friend_offers = @friend_requests = FriendRequest.none
    end
  end

  def create
    friend_request = current_user.friend_requests.build(requestee_id: params[:friend_id], accepted: false)
    if friend_request.save
      flash[:success] = "Friend request sent to #{User.find(params[:friend_id])}."
      redirect_to users_path
    else
      flash.now[:error] = "An error has occured"
    end
  end
end
