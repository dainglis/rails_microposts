class Micropost < ApplicationRecord
    belongs_to :user
    
    # Ensures that the content field must not be empty
    # and cannot exceed 140 characters
    validates :content, 
        length: { maximum: 140 },
        presence: true
end
