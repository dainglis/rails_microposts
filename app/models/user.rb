class User < ApplicationRecord
    has_many :microposts
    
    # Adds validation to the 'name' and 'email'
    # symbols of a user, ensuring they cannot be empty
    validates :name,
        presence: true
        
    validates :email,
        presence: true
end
