class StaticPagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home]
  def home
    redirect_to posts_path if current_user
  end
end
