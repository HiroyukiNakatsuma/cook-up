class Account < ApplicationRecord
  before_save {self.email.downcase!}

  validates :last_name, presence: true, length: {maximum: 50}
  validates :first_name, presence: true, length: {maximum: 50}
  VALID_USER_NAME_REGEX = /[A-Za-z\d.]+/
  validates :user_name, presence: true, length: {in: 5..15}, format: {with: VALID_USER_NAME_REGEX}, uniqueness: true
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: {maximum: 255}, format: {with: VALID_EMAIL_REGEX}, uniqueness: {case_sensitive: false}
  has_secure_password
  validates :password, presence: true, length: {minimum: 6}
end
