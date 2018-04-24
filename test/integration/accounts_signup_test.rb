require 'test_helper'

class AccountsSignupTest < ActionDispatch::IntegrationTest

  test "invalid signup information" do
    get signup_path
    assert_no_difference 'Account.count' do
      post signup_path, params: {account: {last_name: " ",
                                           first_name: " ",
                                           user_name: "hoge@fuga",
                                           email: "account@invalid",
                                           password: "foo",
                                           password_confirmation: "bar"}}
    end
    assert_template 'accounts/new'
    assert_select '#error_explanation .alert'
    assert_select '#error_explanation li', 6
  end

  test "valid signup information" do
    get signup_path
    assert_difference 'Account.count', 1 do
      post signup_path, params: {account: {last_name: "Example",
                                           first_name: "Account",
                                           user_name: "Test01",
                                           email: "account@example.com",
                                           password: "password01",
                                           password_confirmation: "password01"}}
    end
    follow_redirect!
    assert_template root_path
    assert_not flash.empty?
  end
end
