class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy, :toggle_completed]
  def index 
    @sort_order = params[:order] == 'desc' ? 'desc' : 'asc'
    @tasks = Task.order(status: @sort_order)
    @tasks = Task.all

    if params[:category].present?
      @tasks = @tasks.where(category_id: params[:category])
    end
  
    if params[:status].present?
      @tasks = @tasks.where(status: params[:status])
    end
  
    case params[:order]
    when 'description_asc'
      @tasks = @tasks.order(description: :asc)
    when 'description_desc'
      @tasks = @tasks.order(description: :desc)
    when 'status_asc'
      @tasks = @tasks.order(status: :asc)
    when 'status_desc'
      @tasks = @tasks.order(status: :desc)
    end

  end

  def new
    @task = Task.new
    @categories = Category.all
  end

  def edit
    @task = Task.find(params[:id])
    @categories = Category.all
  end


  def create
    @task = Task.new(task_params)
    if @task.save
      redirect_to tasks_path, notice: "Task was successfully created."
    else
      @categories = Category.all  # Make sure to load categories again if there's a validation error
      render :new
    end
  end

  def show
    @task = Task.find(params[:id])
  end


  def update
    @task = Task.find(params[:id])
    @categories = Category.all
    if @task.update(task_params)
      redirect_to tasks_path, notice: "Task successfully updated."
    else
      render :edit
    end
  end

  def destroy
    @task.destroy!
    redirect_to tasks_path, notice: "Task successfully deleted."
    # redirect_to tasks_path, notice: "Task successfully deleted."
    # format.html{redirect_to task_path, notice: "Task Successfully deleted"}
  end

  def toggle_completed
    @task.update(is_completed: !@task.is_completed)
  
    respond_to do |format|
      format.html { redirect_to tasks_path, notice: 'Task status was successfully updated.' }
      format.json { render json: @task }
    end
  end  
  private

  def set_task
    @task = Task.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:name, :category_id, :is_completed, :status)
  end

  
end
