class User < ApplicationRecord
  # initialize a remember_token attribute
  attr_accessor :remember_token, :activation_token, :reset_token

  # downcase the email address before the save function is run
  before_save :downcase_email

  before_create :create_activation_digest

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
                       length: { minimum: 6 },
                       allow_nil: true

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
  def authenticated?(attribute, token)
    digest = self.send("#{attribute}_digest")
    # if the remember digest is nil, we are not authenticated
    return false if digest.nil?
    # otherwise, does the digest match the token?
    BCrypt::Password.new(digest).is_password?(token)
  end

  def activate
    update_columns(activated: true, activated_at: Time.zone.now)
  end

  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  def create_reset_digest
    self.reset_token = User.new_token
    update_columns(reset_digest: User.digest(reset_token), reset_sent_at: Time.zone.now)
  end

  def send_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  def password_reset_expired?
    # the following means 'reset was sent EARLIER than two hours ago'
    reset_sent_at < 2.hours.ago
  end

  private

    def downcase_email
      email.downcase!
    end

    def create_activation_digest
      self.activation_token = User.new_token
      self.activation_digest = User.digest(activation_token)
    end

end
