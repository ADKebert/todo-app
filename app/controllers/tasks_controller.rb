class TasksController < ApplicationController
  before_action :set_task, only: [:update, :destroy]
  def index
    render json: User.find(params[:user_id]).tasks
  end

  def scheduled
    tasks = User.find(params[:user_id]).tasks
    # Currently using default buffer of 10 between tasks
    render json: Scheduler.pick_next(tasks, params[:time_block].to_i, 10)
  end

  def create
    render json: Task.create(task_params)
  end

  def update
    if @task.update(task_params)
      # Find the standard codes for success/failure
      # Return the errors on failure
      # return status: ###
      render json: @task
    else
      render json: { status: "failed" }
    end
  end

  def destroy
    if @task.destroy
      render json: { status: "success" }
    else
      render json: { status: "failed" }
    end
  end

  private
  def set_task
    @task = Task.find(params[:id])
  end

  def task_params
    params.permit(:title, :description, :estimated_duration, :deadline, :time_sensitive, :start_time, :end_time, :user_id)
  end
end
