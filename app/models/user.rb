class User < ApplicationRecord
  VALID_EMAIL_REGEX = Settings.email_regex
  USERS_PARAMS = %i(name email password password_confirmation).freeze

  before_save :downcase_email

  validates :name, presence: true, length: {maximum: Settings.user.name_length}
  validates :email, presence: true,
                    length: {maximum: Settings.user.email_length},
                    format: {with: VALID_EMAIL_REGEX},
                    uniqueness: true
  validates :password, presence: true,
                       length: {minimum: Settings.user.password_length}
  has_secure_password

  class << self
    def digest string
      cost = if ActiveModel::SecurePassword.min_cost
               BCrypt::Engine::MIN_COST
             else
               BCrypt::Engine.cost
             end
      BCrypt::Password.create string, cost: cost
    end

    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  private

  def downcase_email
    email.downcase!
  end
end
