class AccountsController < ApplicationController

  def new
    @account = Account.new
  end

  def create
    @account = Account.new(account_params)
    if @account.save
      # 保存の成功。
    else
      render 'new'
    end
  end

  private

  def account_params
    params.require(:account).permit(:last_name, :first_name, :user_name, :email, :password, :password_confirmation)
  end

end
