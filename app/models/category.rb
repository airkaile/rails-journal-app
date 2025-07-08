# app/models/category.rb
class Category < ApplicationRecord
  belongs_to :user
  has_many :tasks, dependent: :destroy

  validates :title,
    presence: { message: "is required" },
    uniqueness: {
      scope: :user_id,
      message: "already exists in your categories"
    },
    length: {
      maximum: 50,
      too_long: "is too long (max 50 characters)"
    }

  validates :details,
    length: {
      maximum: 300,
      too_long: "is too long (max 300 characters)"
    }
end
