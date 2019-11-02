class PostsController < ApplicationController
  def index
    @posts = current_user.post_feed
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
