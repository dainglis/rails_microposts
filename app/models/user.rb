class User < ApplicationRecord
    # Constants for email validation
    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
    VALID_EMAIL_MAX_LEN = 255

    # Assigns relation with 'micropost' model
    has_many :microposts

    
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
        length: { minimum: 8 }

    validates :password_confirmation,
        presence: true

    # Forces the new user's email to be saved as lowercase
    before_save { self.email = email.downcase }
end
