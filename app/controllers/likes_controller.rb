class LikesController < ApplicationController
    before_action :get_post

    def create
        @likes = @feed_post.likes.where(user: current_user)
        @feed_post.likes.create(user: current_user) if @likes.empty? # create a like, if one doesn't already exist

        redirect_to(request.referer || root_path)
    end

    def destroy
        @likes = @feed_post.likes.where(user: current_user)
        @likes.delete_all # dont instantiate, delete directly

        redirect_to(request.referer || root_path)
    end

    private

        def get_post
            @feed_post = Post.find(params[:post_id])
        end
end
