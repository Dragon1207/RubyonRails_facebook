class CommentsController < ApplicationController
    def create
        post = Post.find_by(id: params[:post_id])
        comment = post.comments.build(text: params[:text], author: current_user)

        if comment.save
            redirect_to(request.referer || root_url)
        else
            redirect_to post_url(post)
        end
    end

    def destroy
        post = Post.find_by(id: params[:post_id])
        comment = post.comments.find(params[:id])

        if comment.author_id == current_user.id
            comment.destroy
        end
        redirect_to post_url(post)
    end
end
