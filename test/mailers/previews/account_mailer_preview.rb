# Preview all emails at http://localhost:3002/rails/mailers/account_mailer
class AccountMailerPreview < ActionMailer::Preview

  def password_reset
    account = Account.first
    account.reset_token = Account.new_token
    AccountMailer.password_reset(account)
  end
end
