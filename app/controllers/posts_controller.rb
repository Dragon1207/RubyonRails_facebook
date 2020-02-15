class PostsController < ApplicationController
  def index
    @posts = current_user.post_feed
  end

  def show
    @posts = Post.select("posts.*",
      "COUNT(likes.user_id) AS like_count",
      "COUNT(ul.user_id) AS user_likes")
      .left_joins(:likes)
      .joins("LEFT JOIN likes ul ON ul.post_id=posts.id AND ul.user_id=#{current_user.id}")
      .where(id: params[:id])
      .group(:id)
      .includes(:author, comments: :author)
  end

  def create
    new_post = current_user.posts.build(safe_params)
    if new_post.save
      flash[:success] = "Post created"
    else
      flash[:error] = "Post not created"
    end
    redirect_to posts_url
  end

  private

    def safe_params
      params.require(:post).permit(:text)
    end
end
