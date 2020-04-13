class User < ApplicationRecord
  # Constants for email validation
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  VALID_EMAIL_MAX_LEN = 255

  # Constants for name validation
  VALID_NAME_MAX_LEN = 80

  # Assigns relation with 'micropost' model
  has_many :microposts, dependent: :destroy

  # Assigns relation with other users, through "relationships" table
  has_many :active_relationships, 
      class_name: "Relationship",
      foreign_key: "follower_id",
      dependent: :destroy
  has_many :passive_relationships,
      class_name: "Relationship",
      foreign_key: "followed_id",
      dependent: :destroy

  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower

  attr_accessor :remember_token, :activation_token, :reset_token

  
  # Adds validation to the 'name' and 'email'
  # symbols of a user, ensuring they cannot be empty
  validates :name,
      presence: true,
      length: { maximum: VALID_NAME_MAX_LEN }
      
  validates :email,
      presence: true,
      length: { maximum: VALID_EMAIL_MAX_LEN }, 
      format: { with: VALID_EMAIL_REGEX },
      uniqueness: { case_sensitive: false }

  has_secure_password
  validates :password,
      length: { minimum: 8 },
      allow_nil: true


  # Forces the new user's email to be saved as lowercase
  before_save :downcase_email

  # Generates and assigns activation token and digest
  before_create :create_activation_digest 


  # Defines a 'feed' of microposts
  def feed
    following_ids = "SELECT followed_id FROM relationships
                    WHERE follower_id = :user_id"
    Micropost.where("user_id IN (#{following_ids})
                    OR user_id = :user_id", user_id: id)
  end


  # helpers for the User model
  def downcase_email
    self.email = email.downcase
  end

  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  def forget
    update_attribute(:remember_digest, nil)
  end

  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end


  ### User activation methods
  #
  def create_activation_digest
    self.activation_token = User.new_token
    self.activation_digest = User.digest(activation_token)
  end

  def activate
    update_columns(activated: true,
                   activated_at: Time.zone.now )
  end

  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end


  ### Password reset methods
  #
  def create_reset_digest
    self.reset_token = User.new_token
    update_columns(reset_digest: User.digest(reset_token),
                   reset_sent_at: Time.zone.now)
  end

  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end



  ### User relationship methods
  #
  def follow(other_user)
    following << other_user
  end

  def unfollow(other_user)
    following.delete(other_user)
  end

  def following?(other_user)
    following.include?(other_user)
  end


  ### Static methods for the User class
  #
  class << self
    def digest(string) 
      cost = ActiveModel::SecurePassword.min_cost ?
          BCrypt::Engine::MIN_COST :
          BCrypt::Engine.cost
      BCrypt::Password.create(string, cost: cost)
    end

  
    def new_token
      SecureRandom.urlsafe_base64
    end
  end
end
