class Task < ApplicationRecord
  belongs_to :category
  belongs_to :user

  validates :title, presence: true
  validates :due_date, presence: true
  validates :category_id, presence: true

  scope :today, -> { where(due_date: Date.today) }
  scope :incomplete, -> { where(completed: false) }

  # Ensure task belongs to user's category
  validate :category_belongs_to_user

  private

  def category_belongs_to_user
    if category && category.user != user
      errors.add(:category, "must be one of your categories")
    end
  end
end
