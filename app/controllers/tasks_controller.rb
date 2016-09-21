class TasksController < ApplicationController
  def index
    render json: User.find(params[:user_id]).tasks
  end

  def create
    render json: Task.create(task_params)
  end

  private
  def task_params
    params.permit(:title, :description, :estimated_duration, :deadline, :time_sensitive, :start_time, :end_time, :user_id)
  end
end
