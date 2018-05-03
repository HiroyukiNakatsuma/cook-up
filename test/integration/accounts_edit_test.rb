require 'test_helper'

class AccountsEditTest < ActionDispatch::IntegrationTest

  def setup
    @account = accounts(:michael)
  end

  test "unsuccessful edit" do
    log_in_as(@account)
    get config_path
    assert_template 'accounts/edit'
    patch accounts_update_path, params: {account: {last_name: "",
                                                   first_name: "",
                                                   user_name: "",
                                                   email: "foo@invalid",
                                                   password: "foo",
                                                   password_confirmation: "bar"}}
    assert_template 'accounts/edit'
  end

  test "successful edit" do
    log_in_as(@account)
    get config_path
    assert_template 'accounts/edit'
    last_name = "Foo"
    first_name = "Bar"
    user_name = "FooBar"
    email = "foo@bar.com"
    patch accounts_update_path, params: {account: {last_name: last_name,
                                                   first_name: first_name,
                                                   user_name: user_name,
                                                   email: email,
                                                   password: "",
                                                   password_confirmation: ""}}
    assert_not flash.empty?
    assert_redirected_to root_path
    @account.reload
    assert_equal last_name, @account.last_name
    assert_equal first_name, @account.first_name
    assert_equal user_name, @account.user_name
    assert_equal email, @account.email
  end

  test "edit need login" do
    get config_path
    assert_not flash.empty?
    assert_redirected_to login_path
    log_in_as(@account)
    assert_redirected_to config_path
  end

  test "update need login" do
    last_name = "Foo"
    first_name = "Bar"
    user_name = "FooBar"
    email = "foo@bar.com"
    patch accounts_update_path, params: {account: {last_name: last_name,
                                                   first_name: first_name,
                                                   user_name: user_name,
                                                   email: email,
                                                   password: "",
                                                   password_confirmation: ""}}
    assert_not flash.empty?
    assert_redirected_to login_path
    @account.reload
    assert_not_equal last_name, @account.last_name
    assert_not_equal first_name, @account.first_name
    assert_not_equal user_name, @account.user_name
    assert_not_equal email, @account.email
  end
end
