require 'test_helper'

class ShowPostPageTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  test "show post" do
    # sign in
    sign_in users(:dave)


    post = posts(:first_post)

    ## go to post page
    get post_path(post)
    assert_response :success

    ## post content
    assert_match CGI::escapeHTML(post.author.name), response.body         # author's name
    assert_select "time[datetime=?]", post.created_at.strftime("%FT%TZ")  # posted at
    assert_match CGI::escapeHTML(post.text), response.body                # text
    assert_match "#{post.likes.count} like", response.body                # like count

    ## comments
    post.comments.each do |comment|
      assert_match CGI::escapeHTML(comment.author.name), response.body  # comment author
      assert_select ".comment a[href=?]", user_path(comment.author)     # link to comment author
      assert_match CGI::escapeHTML(comment.text), response.body         # comment text
    end

    ## form to add a comment
    assert_select "form[action=?]", post_comments_url(post)
    assert_select "form[action=?] textarea", post_comments_url(post)
  end
end
