class AccountsController < ApplicationController

  def new
    @account = Account.new
  end

  def create
    @account = Account.new(account_params)
    if @account.save
      log_in @account
      flash[:success] = I18n.t("account.signup.success")
      redirect_to root_path
    else
      render 'new'
    end
  end

  def edit
    if logged_in?
      @account = current_account
    else
      redirect_to root_path
    end
  end

  private

  def account_params
    params.require(:account).permit(:last_name, :first_name, :user_name, :email, :password, :password_confirmation)
  end
end
