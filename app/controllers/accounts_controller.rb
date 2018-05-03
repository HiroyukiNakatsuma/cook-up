class AccountsController < ApplicationController

  before_action :check_logged_in, only: [:edit, :update]

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
    @account = current_account
  end

  def update
    @account = Account.find(params[:id])
    if @account.update_attributes(account_params)
      flash[:success] = I18n.t("account.update.success")
      redirect_to root_path
    else
      render 'edit'
    end
  end

  private

  def account_params
    params.require(:account).permit(:last_name, :first_name, :user_name, :email, :password, :password_confirmation)
  end

  def check_logged_in
    unless logged_in?
      flash[:danger] = I18n.t("account.login.need")
      redirect_to login_url
    end
  end
end
