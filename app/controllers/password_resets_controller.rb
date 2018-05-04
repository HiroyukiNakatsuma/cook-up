class PasswordResetsController < ApplicationController
  def new
  end

  def create
    @account = Account.find_by(email: params[:password_reset][:email].downcase)
    if @account
      @account.create_reset_digest
      @account.send_password_reset_email
    end
    flash[:info] = I18n.t("password_reset.send_mail.info")
    redirect_to root_url
  end

  def edit
  end
end
