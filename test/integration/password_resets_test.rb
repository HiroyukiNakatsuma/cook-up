require 'test_helper'

class PasswordResetsTest < ActionDispatch::IntegrationTest

  def setup
    ActionMailer::Base.deliveries.clear
    @account = accounts(:michael)
  end

  test "password resets" do
    get password_resets_new_path
    assert_template 'password_resets/new'
    # メールアドレスが空
    post password_resets_path, params: {password_reset: {email: "  "}}
    assert_not flash.empty?
    assert_template 'password_resets/new'
    # 未登録のメールアドレス
    post password_resets_path, params: {password_reset: {email: "hoge@fuga.com"}}
    assert_not flash.empty?
    assert_redirected_to root_url
    # メールアドレスが有効
    post password_resets_path, params: {password_reset: {email: @account.email}}
    assert_not_equal @account.reset_digest, @account.reload.reset_digest
    assert_equal 1, ActionMailer::Base.deliveries.size
    assert_not flash.empty?
    assert_redirected_to root_url
    # パスワード再設定フォームのテスト
    account = assigns(:account)
    # メールアドレスが無効
    get "#{Settings.url.domain}/password_resets/#{account.reset_token}/edit?email="
    assert_redirected_to root_url
    # メールアドレスが有効で、トークンが無効
    get "#{Settings.url.domain}/password_resets/hogehoge/edit?email=#{account.email}"
    assert_redirected_to root_url
    # メールアドレスもトークンも有効
    get "#{Settings.url.domain}/password_resets/#{account.reset_token}/edit?email=#{account.email}"
    assert_template 'password_resets/edit'
    assert_select "input[name=email][type=hidden][value=?]", account.email
    # 無効なパスワードとパスワード確認
    patch "/password_resets/#{account.reset_token}",
          params: {email: account.email,
                   account: {password: "foobaz01",
                             password_confirmation: "barquux02"}}
    assert_select 'div#error_explanation'
    # パスワードが空
    patch "/password_resets/#{account.reset_token}",
          params: {email: account.email,
                   account: {password: "",
                             password_confirmation: ""}}
    assert_select 'div#error_explanation'
    # 有効なパスワードとパスワード確認
    patch "/password_resets/#{account.reset_token}",
          params: {email: account.email,
                   account: {password: "foobar01",
                             password_confirmation: "foobar01"}}
    assert is_logged_in?
    assert_not flash.empty?
    assert_redirected_to root_path
  end

  test "expired token" do
    get password_resets_new_path
    post password_resets_path, params: {password_reset: {email: @account.email}}
    @account = assigns(:account)
    @account.update_attribute(:reset_sent_at, 3.hours.ago)
    patch "/password_resets/#{@account.reset_token}",
          params: {email: @account.email,
                   account: {password: "foobar01",
                             password_confirmation: "foobar01"}}
    assert_response :redirect
    follow_redirect!
    assert_match /有効期限/i, response.body
  end

  test "reset token nil" do
    get password_resets_new_path
    post password_resets_path, params: {password_reset: {email: @account.email}}
    @account = assigns(:account)
    patch "/password_resets/#{@account.reset_token}",
          params: {email: @account.email,
                   account: {password: "foobar01",
                             password_confirmation: "foobar01"}}
    assert is_logged_in?
    assert_not flash.empty?
    assert_redirected_to root_path
    assert_nil @account.reload.reset_digest
  end
end
