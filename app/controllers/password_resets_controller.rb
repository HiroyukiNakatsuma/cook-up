class PasswordResetsController < ApplicationController

  include ApplicationHelper

  before_action :get_account, only: [:edit, :update]
  before_action :valid_account, only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update]

  def new
  end

  def create
    if params[:password_reset][:email].blank?
      flash[:danger] = I18n.t("password_reset.send_mail.blank")
      render 'new' and return
    end
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

  def update
    if params[:account][:password].empty?
      @account.errors.add(:password, :blank)
      render 'edit'
    elsif @account.update_attributes(account_params)
      log_in @account
      @account.update_attribute(:reset_digest, nil)
      redirect_root_with_success_message(I18n.t("password_reset.update.success"))
    else
      render 'edit'
    end
  end

  private

  def account_params
    params.require(:account).permit(:password, :password_confirmation)
  end

  def get_account
    @account = Account.find_by(email: params[:email])
  end

  def valid_account
    redirect_to root_url unless @account && @account.authenticated?(:reset, params[:reset_token])
  end

  def check_expiration
    if @account.password_reset_expired?
      flash[:danger] = I18n.t("password_reset.expiration.over")
      redirect_to password_resets_new_path
    end
  end
end
