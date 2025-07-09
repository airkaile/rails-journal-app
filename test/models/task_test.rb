require "test_helper"

class TaskTest < ActiveSupport::TestCase
  def setup
    @user = users(:user_one)
    @category = categories(:work_category)
    @task = Task.new(
      title: "Test Task #{SecureRandom.hex(4)}",
      description: "Test description",
      due_date: Date.today,
      completed: false,
      user: @user,
      category: @category
    )
  end

  test "should be valid" do
    assert @task.valid?
  end

  test "title should be present" do
    @task.title = " "
    assert_not @task.valid?
    assert_equal [ "is required" ], @task.errors[:title]
  end

  test "title should not be too long" do
    @task.title = "a" * 101
    assert_not @task.valid?
    assert_equal [ "is too long (max 100 characters)" ], @task.errors[:title]
  end

  test "due_date should not be in past" do
    @task.due_date = Date.yesterday
    assert_not @task.valid?
    assert_equal [ "can't be in the past" ], @task.errors[:due_date]
  end

  test "should belong to user" do
    @task.user = nil
    assert_not @task.valid?
  end

  test "should belong to category" do
    @task.category = nil
    assert_not @task.valid?
  end

  test "scope :today returns tasks due today" do
    today_task = tasks(:work_task)
    future_task = tasks(:personal_task)

    assert_includes Task.today, today_task
    assert_not_includes Task.today, future_task
  end

  test "scope :incomplete returns uncompleted tasks" do
    incomplete_task = tasks(:work_task)
    completed_task = tasks(:personal_task)

    assert_includes Task.incomplete, incomplete_task
    assert_not_includes Task.incomplete, completed_task
  end
end
