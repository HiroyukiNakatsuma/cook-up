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
end
