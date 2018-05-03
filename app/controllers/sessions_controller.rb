class SessionsController < ApplicationController

  include ApplicationHelper

  def new
  end

  def create
    @account = Account.find_by(email: params[:session][:email].downcase)
    if @account && @account.authenticate(params[:session][:password])
      log_in @account
      params[:session][:remember_me] == '1' ? remember(@account) : forget(@account)
      redirect_back_or root_path
    else
      flash.now[:danger] = I18n.t("account.login.error")
      render 'new'
    end
  end

  def destroy
    log_out if logged_in?
    redirect_root_with_success_message(I18n.t("session.logout.success"))
  end
end
