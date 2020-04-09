class User < ApplicationRecord
    # Constants for email validation
    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
    VALID_EMAIL_MAX_LEN = 255

    # Assigns relation with 'micropost' model
    has_many :microposts

    attr_accessor :remember_token

    
    # Adds validation to the 'name' and 'email'
    # symbols of a user, ensuring they cannot be empty
    validates :name,
        presence: true
        
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
    before_save { self.email = email.downcase }

    def remember
      self.remember_token = User.new_token
      update_attribute(:remember_digest, User.digest(remember_token))
    end

    def forget
      update_attribute(:remember_digest, nil)
    end

    def authenticated?(remember_token)
      return false if remember_digest.nil?
      BCrypt::Password.new(remember_digest).is_password?(remember_token)
    end


    # Static methods for the User class
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
