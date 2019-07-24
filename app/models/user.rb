class User
  include Mongoid::Document
  include ActiveModel::SecurePassword

  attr_accessor :remember_token

  field :name, type: String
  field :email, type: String
  field :password_digest, type: String
  field :remember_digest, type: String
  field :admin, type: Boolean, default: false

  has_secure_password

  before_save { self.email = email.downcase }

  validates :name,  presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  validates :password, length: { minimum: 6 }

  # Generates a new remember token, hashes it, and stores the digest.
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  # Returns true if the given token matches the digest.
  def authenticated?(remember_token)
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  # Deletes the internal remember digest to forget a user.
  def forget
    update_attribute(:remember_digest, nil)
  end

  # Returns the hash digest of the provided string
  def self.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # Returns a random token.
  def self.new_token
    SecureRandom.urlsafe_base64
  end
end
