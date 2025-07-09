class TasksController < ApplicationController
  before_action :require_categories, only: [ :new, :create, :today ]
  before_action :set_category, only: [ :new, :create ]
  before_action :set_task, only: [ :show, :edit, :update, :destroy ]
  before_action :set_categories, only: [ :edit, :update ]

  rescue_from ActiveRecord::RecordNotFound, with: :handle_task_not_found

  def today
    @tasks = current_user.tasks.today.incomplete
    render :index
  end

  def show
  end

  def new
    @task = @category.tasks.build(user: current_user, due_date: Date.today)
  end

  def edit
  end

  def create
    @task = @category.tasks.build(task_params.merge(user: current_user))

    if @task.save
      redirect_to [ @category, @task ], notice: "Task was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @task.update(task_params)
      redirect_to [ @task.category, @task ], notice: "Task was successfully updated."
    else
      flash.now[:alert] = "Failed to update task"
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    category = @task.category
    @task.destroy
    redirect_to category_path(category), notice: "Task was successfully destroyed."
  end

  private

  def handle_task_not_found
    logger.error "Task not found for user #{current_user.id}"
    redirect_to today_tasks_path, alert: "Task not found or you don't have permission to access it"
  end

  def require_categories
    if current_user.categories.none?
      redirect_to categories_path, alert: "You need to create at least one category first"
    end
  end

  def set_category
    @category = current_user.categories.find(params[:category_id])
  end

  def set_task
    @task = current_user.tasks.find(params[:id])
  end

  def set_categories
    @categories = current_user.categories
  end

  def task_params
    params.require(:task).permit(:title, :description, :due_date, :completed)
  end
end
