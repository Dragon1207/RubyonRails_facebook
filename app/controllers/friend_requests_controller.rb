class FriendRequestsController < ApplicationController
  def index
    @friend_offers = current_user.friend_offers
    @friend_requests = current_user.friend_requests
  end
end
