require "test_helper"

class TasksControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = users(:user_one)
    @other_user = users(:user_two)
    @category = categories(:work_category)
    @task = tasks(:work_task)
    sign_in @user
  end

  test "should get today" do
    get today_tasks_url
    assert_response :success
    assert_select "h1", "Today's Tasks"
  end

  test "should redirect if no categories exist" do
    @user.categories.destroy_all
    get new_category_task_url(@user.categories.first || 1) # Fallback ID if no categories
    assert_redirected_to categories_url
    assert_equal "You need to create at least one category first", flash[:alert]
  end

  test "should get new" do
    get new_category_task_url(@category)
    assert_response :success
  end

  test "should create task" do
    assert_difference("Task.count") do
      post category_tasks_url(@category), params: {
        task: {
          title: "New Task",
          description: "Task description",
          due_date: Date.today
        }
      }
    end

    assert_redirected_to category_task_url(@category, Task.last)
    assert_equal "Task was successfully created.", flash[:notice]
  end

  test "should show task" do
    get category_task_url(@category, @task)
    assert_response :success
    assert_select "h1", @task.title
  end

  test "should get edit" do
    get edit_category_task_url(@category, @task)
    assert_response :success
  end

  test "should update task" do
    patch category_task_url(@category, @task), params: {
      task: {
        title: "Updated Task"
      }
    }
    assert_redirected_to category_task_url(@category, @task)
    @task.reload
    assert_equal "Updated Task", @task.title
    assert_equal "Task was successfully updated.", flash[:notice]
  end

  test "should destroy task" do
    assert_difference("Task.count", -1) do
      delete category_task_url(@category, @task)
    end

    assert_redirected_to category_path(@category)
    assert_equal "Task was successfully destroyed.", flash[:notice]
  end

  test "should not access other user's tasks" do
    sign_out @user
    sign_in @other_user

    get category_task_url(@category, @task)
    assert_redirected_to today_tasks_path
    assert_equal "Task not found or you don't have permission to access it", flash[:alert]
  end

  test "should handle record not found" do
    invalid_id = Task.maximum(:id).to_i + 1
    get category_task_url(@category, invalid_id)
    assert_redirected_to today_tasks_path
    assert_equal "Task not found or you don't have permission to access it", flash[:alert]
  end
end
