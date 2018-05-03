require 'test_helper'

class AccountsWithdrawTest < ActionDispatch::IntegrationTest

  def setup
    @account = accounts(:michael)
  end

  test "unsuccessful withdraw" do
    assert_difference 'Account.count', 0 do
      delete withdraw_path
    end
    log_in_as(@account)
    delete withdraw_path
    assert_difference 'Account.count', 0 do
      delete withdraw_path
    end
  end

  test "successful withdraw" do
    get withdraw_path
    assert_not flash.empty?
    assert_redirected_to login_path
    log_in_as(@account)
    assert_redirected_to withdraw_path
    assert_difference 'Account.count', -1 do
      delete withdraw_path
    end
    follow_redirect!
    assert_template root_path
    assert_not flash.empty?
    assert_not is_logged_in?
  end
end
