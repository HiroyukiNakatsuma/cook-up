class AccountsController < ApplicationController

  before_action :check_logged_in, only: [:edit, :update, :withdraw, :delete]

  def new
    @account = Account.new
  end

  def create
    @account = Account.new(account_params)
    if @account.save
      log_in @account
      redirect_root_with_success_message(I18n.t("account.signup.success"))
    else
      render 'new'
    end
  end

  def edit
    @account = current_account
  end

  def update
    @account = Account.find(current_account.id)
    if @account.update_attributes(account_params)
      redirect_root_with_success_message(I18n.t("account.update.success"))
    else
      render 'edit'
    end
  end

  def withdraw
  end

  def delete
    Account.find(current_account.id).destroy
    log_out
    redirect_root_with_success_message(I18n.t("account.withdraw.success"))
  end

  private

  def account_params
    params.require(:account).permit(:last_name, :first_name, :user_name, :email, :password, :password_confirmation)
  end

  def check_logged_in
    unless logged_in?
      store_location
      flash[:danger] = I18n.t("account.login.need")
      redirect_to login_url
    end
  end

  def redirect_root_with_success_message(message)
    flash[:success] = message
    redirect_to root_path
  end
end
