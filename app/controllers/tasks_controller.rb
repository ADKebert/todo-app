class TasksController < ApplicationController
  before_action :set_task, only: [:update, :destroy]
  def index
    render json: User.find(params[:user_id]).tasks
  end

  def create
    render json: Task.create(task_params)
  end

  def update
    @task.update(task_params)
  end

  def destroy
    @task.destroy
  end

  private
  def set_task
    @task = Task.find(params[:id])
  end

  def task_params
    params.permit(:title, :description, :estimated_duration, :deadline, :time_sensitive, :start_time, :end_time, :user_id)
  end
end
