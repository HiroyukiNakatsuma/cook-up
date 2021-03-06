class Account < ApplicationRecord
  before_save :downcase_email

  attr_accessor :remember_token, :reset_token

  validates :last_name,
            presence: {message: I18n.t("validations.blank")},
            length: {maximum: 50, message: I18n.t("validations.over_length", max_length: 50)}
  validates :first_name,
            presence: {message: I18n.t("validations.blank")},
            length: {maximum: 50, message: I18n.t("validations.over_length", max_length: 50)}
  VALID_USER_NAME_REGEX = /\A(?!\d*\z)[a-zA-Z0-9]+\z/
  validates :user_name,
            length: {in: 5..15, message: I18n.t("validations.not_within_length_range", min_length: 5, max_length: 15)},
            format: {with: VALID_USER_NAME_REGEX},
            uniqueness: {message: I18n.t("validations.already_used")}
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email,
            length: {maximum: 255, message: I18n.t("validations.over_length", max_length: 255)},
            format: {with: VALID_EMAIL_REGEX},
            uniqueness: {case_sensitive: false, message: I18n.t("validations.already_used")}
  has_secure_password
  VALID_PASSWORD_REGEX = /\A(?=.*?[a-z])(?=.*?\d)[a-z\d]{6,255}+\z/i
  validates :password,
            format: {with: VALID_PASSWORD_REGEX},
            allow_nil: true

  def Account.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # ランダムなトークンを返す
  def Account.new_token
    SecureRandom.urlsafe_base64
  end

  # 永続セッションのためにデータベースに記憶する
  def remember
    self.remember_token = Account.new_token
    update_attribute(:remember_digest, Account.digest(remember_token))
  end

  # 渡されたトークンがダイジェストと一致したらtrueを返す
  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  # ログイン情報を破棄する
  def forget
    update_attribute(:remember_digest, nil)
  end

  # パスワード再設定の属性を設定する
  def create_reset_digest
    self.reset_token = Account.new_token
    update_columns(reset_digest: Account.digest(reset_token), reset_sent_at: Time.zone.now)
  end

  # パスワード再設定のメールを送信する
  def send_password_reset_email
    AccountMailer.password_reset(self).deliver_now
  end

  # パスワード再設定の期限が切れている場合はtrueを返す
  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end

  private

  def downcase_email
    self.email = email.downcase
  end
end
