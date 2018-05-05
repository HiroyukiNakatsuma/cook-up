require 'test_helper'

class AccountMailerTest < ActionMailer::TestCase

  test "password_reset" do
    account = accounts(:michael)
    account.reset_token = Account.new_token
    mail = AccountMailer.password_reset(account)
    assert_equal "【パスワード再設定】cook-up", mail.subject
    assert_equal [account.email], mail.to
    assert_equal ["noreply@example.com"], mail.from
    assert_match account.reset_token, mail.text_part.body.to_s.encode('UTF-8')
    assert_match account.email, mail.text_part.body.to_s.encode('UTF-8')
  end
end
