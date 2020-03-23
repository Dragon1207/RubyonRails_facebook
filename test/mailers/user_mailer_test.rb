require 'test_helper'

class UserMailerTest < ActionMailer::TestCase
  test "welcome mail" do
    test_user = users(:alice)
    # create an email
    email = UserMailer.welcome_mail(test_user)

    # Send the email, then test that it got queued
    assert_emails 1 do
      email.deliver_now
    end

    # Test the body of the sent email contains what we expect it to
    assert_equal ['noreply@example.org'], email.from
    assert_equal [test_user.email], email.to
    assert_equal 'Welcome to Phacepook', email.subject
    assert_equal read_fixture('welcome.text').join, email.text_part.body.to_s
    assert_equal read_fixture('welcome.html').join.gsub(/\s+/, ' '), email.html_part.body.to_s.gsub(/\s+/, ' ')
  end
end
