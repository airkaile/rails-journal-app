class CategoriesController < ApplicationController
  before_action :set_category, only: [ :show, :edit, :update, :destroy ]

  rescue_from ActiveRecord::RecordNotFound, with: :handle_category_not_found

  def index
    @categories = current_user.categories
  end

  def show
    @tasks = @category.tasks
  end

  def new
    @category = current_user.categories.new
  end

  def edit
  end

  def create
    @category = current_user.categories.new(category_params)

    if @category.save
      redirect_to @category, notice: "Category was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @category.update(category_params)
      redirect_to @category, notice: "Category was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @category.destroy
    redirect_to categories_url, notice: "Category was successfully destroyed."
  end

  private

  def handle_category_not_found
    logger.error "Category not found for user #{current_user.id}"
    redirect_to categories_path, alert: "Category not found or you don't have permission to access it"
  end

  def set_category
    @category = current_user.categories.find(params[:id])
  end

  def category_params
    params.require(:category).permit(:title, :details)
  end
end
