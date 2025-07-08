class Task < ApplicationRecord
  belongs_to :category
  belongs_to :user

  # Validations
  validates :title,
    presence: { message: "is required" },
    length: { maximum: 100, too_long: "is too long (max 100 characters)" }

  validates :due_date,
    presence: true,
    comparison: {
      greater_than_or_equal_to: Date.today,
      message: "can't be in the past"
    }

  scope :today, -> { where(due_date: Date.today) }
  scope :incomplete, -> { where(completed: false) }
end
