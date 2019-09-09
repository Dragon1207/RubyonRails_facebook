class UsersController < ApplicationController
  def index
    @users = current_user.strangers
  end

  def show
  end
end
