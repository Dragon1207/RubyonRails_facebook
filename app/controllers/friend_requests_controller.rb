class FriendRequestsController < ApplicationController
  def index
    unless current_user.nil?
      @friend_offers = current_user.friend_offers
      @friend_requests = current_user.friend_requests
    else
      @friend_offers = @friend_requests = FriendRequest.none
    end
  end
end
