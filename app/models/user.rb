class User < ApplicationRecord
  # initialize a remember_token attribute
  attr_accessor :remember_token

  # downcase the email address; save the original capitalization
  before_save { email.downcase! }
  
  # create a new token for persistent user sessions
  def User.new_token
    SecureRandom.urlsafe_base64
  end

  # create a secure digest of a string
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

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

  # remember session based on token
  def remember
    # (re)set the token attribute with a new token
    update_attribute(:remember_token, User.new_token)
    # create a digest and update the user to include it
    update_attribute(:remember_digest, User.digest(self.remember_token))
  end

  # end the persistent session
  def forget
    update_attribute(:remember_digest, nil)
  end

  # Returns true if the token matches the digest
  def authenticated?(remember_token)
    # if the remember digest is nil, we are not authenticated
    return false if remember_digest.nil?
    # otherwise, does the digest match the token?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

end
