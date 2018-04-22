class Account < ApplicationRecord
  before_save {self.email.downcase!}

  validates :last_name,
            presence: {message: I18n.t("validations.blank")},
            length: {maximum: 50, message: I18n.t("validations.over_length", max_length: 50)}
  validates :first_name,
            presence: {message: I18n.t("validations.blank")},
            length: {maximum: 50, message: I18n.t("validations.over_length", max_length: 50)}
  VALID_USER_NAME_REGEX = /[A-Za-z\d.]+/
  validates :user_name,
            presence: {message: I18n.t("validations.blank")},
            length: {in: 5..15, message: I18n.t("validations.not_within_length_range", min_length: 5, max_length: 15)},
            format: {with: VALID_USER_NAME_REGEX},
            uniqueness: {message: I18n.t("validations.already_used")}
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email,
            presence: {message: I18n.t("validations.blank")},
            length: {maximum: 255, message: I18n.t("validations.over_length", max_length: 255)},
            format: {with: VALID_EMAIL_REGEX},
            uniqueness: {case_sensitive: false, message: I18n.t("validations.already_used")}
  has_secure_password
  validates :password,
            length: {minimum: 6, message: I18n.t("validations.not_enough_length", min_length: 6)}
end
