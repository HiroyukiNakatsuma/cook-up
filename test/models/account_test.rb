require 'test_helper'

class AccountTest < ActiveSupport::TestCase

  def setup
    @account = Account.new(last_name: "Sample",
                           first_name: "Test",
                           user_name: "Test01",
                           email: "account@example.com",
                           password: "foobar01",
                           password_confirmation: "foobar01")
  end

  test "should be valid" do
    assert @account.valid?
  end

  test "last name should not be nil" do
    @account.last_name = nil
    assert_not @account.valid?
  end

  test "last name should not be blank" do
    @account.last_name = "   "
    assert_not @account.valid?
  end

  test "last name should not be over 50" do
    @account.last_name = "a" * 51
    assert_not @account.valid?
  end

  test "first name should not be nil" do
    @account.first_name = nil
    assert_not @account.valid?
  end

  test "first name should not be blank" do
    @account.first_name = "   "
    assert_not @account.valid?
  end

  test "first name should not be over 50" do
    @account.first_name = "a" * 51
    assert_not @account.valid?
  end

  test "user name should not be nil" do
    @account.user_name = nil
    assert_not @account.valid?
  end

  test "user name should not be blank" do
    @account.user_name = "   "
    assert_not @account.valid?
  end

  test "user name should not be too long and too short" do
    @account.user_name = "a" * 16
    assert_not @account.valid?
    @account.user_name = "a" * 4
    assert_not @account.valid?
  end

  test "user name should not be invalid char" do
    @account.user_name = "`~!@\#$%^&*()"
    assert_not @account.valid?
    @account.user_name = "[]{}\\|;:'\",/"
    assert_not @account.valid?
    @account.user_name = "-_<>?=+あ阿α∀"
    assert_not @account.valid?
    @account.user_name = "123456"
    assert_not @account.valid?
  end

  test "user name should be unique" do
    assert @account.save
    same_user_name_account = @account.dup
    same_user_name_account.user_name = "Test01"
    same_user_name_account.email = "account01@example.com"
    assert_not same_user_name_account.valid?
  end

  test "email should not be nil" do
    @account.email = nil
    assert_not @account.valid?
  end

  test "email should not be blank" do
    @account.email = "   "
    assert_not @account.valid?
  end

  test "email should not be over 255" do
    @account.email = ("a" * 244) + "@example.com"
    assert_not @account.valid?
  end

  test "email validation should accept valid addresses" do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |valid_address|
      @account.email = valid_address
      assert @account.valid?, "#{valid_address.inspect} should be valid"
    end
  end

  test "email validation should reject invalid addresses" do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example. foo@bar_baz.com foo@bar+baz.com]
    invalid_addresses.each do |invalid_address|
      @account.email = invalid_address
      assert_not @account.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end

  test "email should be unique" do
    assert @account.save
    same_email_account = @account.dup
    same_email_account.user_name = "Test02"
    same_email_account.email = "account@example.com"
    assert_not same_email_account.valid?
    same_email_account.email.upcase!
    assert_not same_email_account.valid?
  end

  test "email addresses should be saved as lower-case" do
    mixed_case_email = "Foo@ExAMPle.CoM"
    @account.email = mixed_case_email
    @account.save
    assert_equal mixed_case_email.downcase, @account.reload.email
  end

  test "password should not be nil" do
    @account.password = @account.password_confirmation = nil
    assert_not @account.valid?
  end

  test "password should be present" do
    @account.password = @account.password_confirmation = " " * 6
    assert_not @account.valid?
  end

  test "password should have a minimum length" do
    @account.password = @account.password_confirmation = "a" * 5
    assert_not @account.valid?
  end

  test "password should have number" do
    @account.password = @account.password_confirmation = "a" * 6
    assert_not @account.valid?
  end

  test "password should not be equal confirmation" do
    @account.password = "hogefuga"
    assert_not @account.valid?
  end

  test "authenticated? should return false for a user with nil digest" do
    assert_not @account.authenticated?('')
  end
end
