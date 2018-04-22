class Account < ApplicationRecord
  before_save {self.email.downcase!}

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
            format: {with: VALID_PASSWORD_REGEX}
end
