require "test_helper"

class CategoryTest < ActiveSupport::TestCase
  def setup
    @user = users(:user_one)
    @category = Category.new(
      title: "Test Category #{SecureRandom.hex(4)}",
      details: "Test details",
      user: @user
    )
  end

  test "should be valid" do
    assert @category.valid?
  end

  test "title should be present" do
    @category.title = " "
    assert_not @category.valid?
    assert_equal [ "is required" ], @category.errors[:title]
  end

  test "title should be unique per user" do
    existing = categories(:work_category)
    @category.title = existing.title
    assert_not @category.valid?
    assert_equal [ "already exists in your categories" ], @category.errors[:title]
  end

  test "title should not be too long" do
    @category.title = "a" * 51
    assert_not @category.valid?
    assert_equal [ "is too long (max 50 characters)" ], @category.errors[:title]
  end

  test "details should not be too long" do
    @category.details = "a" * 301
    assert_not @category.valid?
    assert_equal [ "is too long (max 300 characters)" ], @category.errors[:details]
  end

  test "should belong to user" do
    @category.user = nil
    assert_not @category.valid?
  end

  test "should have many tasks" do
    category = categories(:work_category)
    assert_equal 1, category.tasks.size
    assert_instance_of Task, category.tasks.first
  end

  test "should destroy associated tasks" do
    category = categories(:work_category)
    assert_difference "Task.count", -1 do
      category.destroy
    end
  end
end
