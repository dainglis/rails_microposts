class Micropost < ApplicationRecord
  # Constant for micropost content validation 
  MICROPOST_MAX_LEN = 140

  # Assigns relation with 'user' model
  belongs_to        :user

  has_one_attached  :image

  default_scope -> { order(created_at: :desc) }

  
  # Ensures that the content field must not be empty
  # and cannot exceed 140 characters
  validates :content, 
      length: { maximum: MICROPOST_MAX_LEN },
      presence: true

  validates :user_id,
      presence: true

  validates :image,
      content_type: {
          in: %w[image/jpeg image/gif image/png],
          message: "must be a valid image format" },
      size: {
          less_than: 5.megabytes,
          message: "should be less than 5MB" }

  # resizes images appropriately
  def display_image
    image.variant(resize_to_limit: [500, 500])
  end
end
