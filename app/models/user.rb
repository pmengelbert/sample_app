class User < ApplicationRecord
  # downcase the email address; save the original capitalization
  before_save { email.downcase! }
  
  # ensure that the name is valid and that it's not longer than 50 chars
  validates :name, presence: true,
     length: { maximum: 50 }

  # ensure the email is a valid one, less than 256 characters, and that it's unique
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true,
     length: { maximum: 255 },
     format: { with: VALID_EMAIL_REGEX },
     uniqueness: { case_sensitive: false }

  # ensure the password is supplied and longer than 5 characters
  validates :password, presence: true,
                       length: { minimum: 6 }

  # enable secure password functionality
  has_secure_password

  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end
end
