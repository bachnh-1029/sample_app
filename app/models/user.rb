class User < ApplicationRecord
  VALID_EMAIL_REGEX = Settings.email_regex

  before_save :downcase_email

  validates :name, presence: true, length: { maximum: Settings.user.name_length }
  validates :email, presence: true, length: { maximum: Settings.user.email_length },
                    format: {with: VALID_EMAIL_REGEX},
                    uniqueness: true
  validates :password, presence: true, length: { minimum: Settings.user.password_length }
  
  has_secure_password
  private

  def downcase_email
    email.downcase!
  end
end
