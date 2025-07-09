require "test_helper"

class CategoriesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = users(:user_one)
    @category = categories(:work_category)
    sign_in @user
  end

  test "should get index" do
    get categories_url
    assert_response :success
    assert_select "h1", "My Categories"
  end

  test "should get new" do
    get new_category_url
    assert_response :success
  end

  test "should create category" do
    assert_difference("Category.count") do
      post categories_url, params: {
        category: {
          title: "New Category",
          details: "New details"
        }
      }
    end

    assert_redirected_to category_url(Category.last)
    assert_equal "Category was successfully created.", flash[:notice]
  end

  test "should show category" do
    get category_url(@category)
    assert_response :success
    assert_select "h1", @category.title
  end

  test "should get edit" do
    get edit_category_url(@category)
    assert_response :success
  end

  test "should update category" do
    patch category_url(@category), params: {
      category: {
        title: "Updated Title"
      }
    }
    assert_redirected_to category_url(@category)
    @category.reload
    assert_equal "Updated Title", @category.title
    assert_equal "Category was successfully updated.", flash[:notice]
  end

  test "should destroy category" do
    assert_difference("Category.count", -1) do
      delete category_url(@category)
    end

    assert_redirected_to categories_url
    assert_equal "Category was successfully destroyed.", flash[:notice]
  end

  test "should not access when not authenticated" do
    sign_out @user
    get categories_url
    assert_redirected_to new_user_session_url
  end

  test "should handle record not found" do
    invalid_id = Category.maximum(:id).to_i + 1
    get category_url(invalid_id)
    assert_redirected_to categories_url
    assert_equal "Category not found or you don't have permission to access it", flash[:alert]
  end
end
