require 'test_helper'

class VisitUserProfileTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  include ActionView::Helpers::TextHelper

  def setup
    @alice = users(:alice)
    sign_in @alice

    @users_to_check = [@alice, users(:eric), users(:bob), users(:fred), users(:carl)]
  end

  test "user's basic info is displayed" do
    @users_to_check.each do |u|
      get user_path(u)

      assert_select 'h1', u.name,                                     "User page should contain user's name"
      assert_select '.profile > img[src=?]', gravatar_url_for(u), 1,  "User page should contain gravatar photo"
    end
  end

  test "own profile buttons" do
    get user_path(@alice)

    assert_select "form[action=?]", posts_url   # has form to wtite posts

    assert_select "form[action=?]", friend_requests_path, false,              "This page mustn't contain 'add friend' button"
    assert_select "form > submit", {text: "Accept Friend Request", count: 0}, "This page mustn't contain 'accept friend request' button"
    assert_select "a", {text: "Revoke Request", count: 0},                    "This page mustn't contain 'revoke' button"
    assert_select "a", {text: "Delete Request", count: 0},                    "This page mustn't contain 'remove' button"
  end

  test "stranger's profile buttons" do
    get user_path(users(:eric))

    assert_select "form[action=?]", posts_url, false   # no form to wtite posts

    assert_select "form[action=?]", friend_requests_path, true,               "This page must contain 'add friend' button"
    assert_select "form > submit", {text: "Accept Friend Request", count: 0}, "This page mustn't contain 'accept friend request' button"
    assert_select "a", {text: "Revoke Request", count: 0},                    "This page mustn't contain 'revoke' button"
    assert_select "a", {text: "Delete Request", count: 0},                    "This page mustn't contain 'remove' button"
  end

  test "asked for friendship buttons" do
    get user_path(users(:bob))

    assert_select "form[action=?]", posts_url, false   # no form to wtite posts

    assert_select "form[action=?]", friend_requests_path, false,              "This page mustn't contain 'add friend' button"
    assert_select "form > submit", {text: "Accept Friend Request", count: 0}, "This page mustn't contain 'accept friend request' button"
    assert_select "a", {text: "Revoke Request", count: 1},                    "This page must contain 'revoke' button"
    assert_select "a", {text: "Delete Request", count: 0},                    "This page mustn't contain 'remove' button"
  end

  test "has been asked for friendship buttons" do
    get user_path(users(:fred))

    assert_select "form[action=?]", posts_url, false   # no form to wtite posts

    assert_select "form[action=?]", friend_requests_path, false,                              "This page mustn't contain 'add friend' button"
    assert_select "form > input[type=submit][value=?]", "Accept Friend Request", {count: 1},  "This page must contain 'accept friend request' button"
    assert_select "a", {text: "Revoke Request", count: 0},                                    "This page mustn't contain 'revoke' button"
    assert_select "a", {text: "Delete Request", count: 1},                                    "This page must contain 'remove' button"
  end

  test "friends buttons" do
    get user_path(users(:carl))

    assert_select "form[action=?]", posts_url, false   # no form to wtite posts

    assert_select "form[action=?]", friend_requests_path, false,                              "This page mustn't contain 'add friend' button"
    assert_select "form > input[type=submit][value=?]", "Accept Friend Request", {count: 0},  "This page mustn't contain 'accept friend request' button"
    assert_select "a", {text: "Revoke Request", count: 0},                                    "This page mustn't contain 'revoke' button"
    assert_select "a", {text: "Delete Request", count: 0},                                    "This page mustn't contain 'remove' button"
    assert_select "a", {text: "Remove from Friends", count: 1},                               "This page must contain 'remove from friends' button" 
  end

  test "displays posts" do
    @users_to_check.each do |user|
      get user_path(user)

      posts = user.own_posts.limit(10)

      # verify posts are displayed
      posts.each do |p|
        assert_match CGI::escapeHTML(p.text), response.body 
      end

      # check for '.post-display' divs
      assert_select '.post-display' do |post_elements|
        # for each element
        post_elements.each do |element|
          post_text = element.css('.post-content p').text   # get post by text. not ideal but good enough
          post = posts.where(text: post_text).first

          # test for post data
          assert_select '.byline .user-name',                     user.name,                    "Post div should contain author name"
          assert_select '.date-time a[href=?]', post_path(post),  1,                            "Post div should contain link to post"
          assert_select '.post-buttons > form',                   post.user_likes > 0 ? 0 : 1,  "Post div should contain like button (if not liked)"
          assert_select '.post-buttons > a',                      post.user_likes > 0 ? 1 : 0,  "Post div should contain unlike button (if liked)"
          assert_match pluralize(post.like_count, 'like'),        element.text,                 "Post div should contain like count"
          assert_match pluralize(post.comments.size, 'comment'),  element.text,                 "Post div should contain comment count"

          # test for post comments
          if post.comments.size > 0
            comments = post.comments
            # check for '.comment' divs
            assert_select '.comment' do |comment_elements|
              comment_elements.each do |element|
                comment_text = element.css('p').text   # get post by text. not ideal but good enough
                comment = comments.where(text: comment_text).first

                assert_select 'a[href=?]', user_path(comment.author), 1,                                "Comment should have a link to author"
                assert_select 'a[href=?]', comment_path(comment),     comment.author == @alice ? 1 : 0, "Comment should have a delete link if user is author; else not"
                assert_select 'p',                                    comment.text,                     "Comment text should be shown"
              end
            end
          else
            assert_select '.comment', 0
          end

          # test comment form
          assert_select 'form[action=?]', post_comments_path(post), 1, "Post should have comment html form"
        end
      end
    end
  end
end
