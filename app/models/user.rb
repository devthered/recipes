class User
  include Mongoid::Document
  include ActiveModel::SecurePassword

  attr_accessor :remember_token, :activation_token, :reset_token
  before_create :create_activation_digest
  before_save :downcase_email

  default_scope { order(name: :asc, title: :asc) }

  has_many :recipes, class_name: 'Recipe', inverse_of: :owner, dependent: :destroy
  has_and_belongs_to_many :liked_recipes, class_name: 'Recipe', inverse_of: :likers

  field :name, type: String
  field :email, type: String
  field :admin, type: Boolean, default: false
  field :remember_digest, type: String
  field :activation_digest, type: String
  field :activated, type: Boolean, default: false
  field :activated_at, type: DateTime
  field :reset_digest, type: String
  field :reset_sent_at, type: DateTime
  field :password_digest, type: String
  has_secure_password

  validates :name,  presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  validates :password, length: { minimum: 6 }
  
  #
  # Instance Methods
  #

  # Returns true if the given token matches the digest for the specified attribute.
  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  # Generates a new remember token, hashes it, and stores the digest.
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  # Deletes the internal remember digest to forget a user.
  def forget
    update_attribute(:remember_digest, nil)
  end

  # Generates a new password reset token, hashes it, and stores the digest.
  def create_reset_digest
    self.reset_token = User.new_token
    update_attribute(:reset_digest, User.digest(reset_token))
    update_attribute(:reset_sent_at, Time.zone.now)
  end

  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end

  def like(recipe)
    self.liked_recipes.push(recipe)
  end

  def unlike(recipe)
    self.liked_recipes.delete(recipe)
  end

  #
  # Class Methods
  #

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

  #
  # Private Instance Methods
  #

  private

    def downcase_email
      self.email = email.downcase
    end

    def create_activation_digest
      self.activation_token = User.new_token
      self.activation_digest = User.digest(activation_token)
    end
end
