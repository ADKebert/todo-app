class TasksController < ApplicationController
  before_action :set_task, only: [:update, :destroy]
  before_action :current_user
  def index
    if @user
      render json: @user.tasks
    else
      render json: []
    end
  end

  def scheduled
    if @user
      tasks = @user.tasks
      # Currently using default buffer of 10 between tasks
      render json: Scheduler.pick_next(tasks, params[:time_block].to_i, 10)
    else
      render json: []
    end
  end

  def create
    if @user
      task = @user.tasks.create(task_params)
      render json: task
    else
      render json: { status: "no user" }
    end
  end

  def update
    if @user == @task.user && @task.update(task_params)
      # Find the standard codes for success/failure
      # Return the errors on failure
      # return status: ###
      render json: @task
    else
      render json: { status: "failed" }
    end
  end

  def destroy
    if @user == @task.user && @task.destroy
      render json: { status: "success" }
    else
      render json: { status: "failed" }
    end
  end

  private
  def set_task
    @task = Task.find(params[:id])
  end

  def current_user
    token = decoded_token
    if token.empty?
      false
    else
      @user = User.find_by(google_id: token["google_id"])
    end
  end

  def task_params
    params.permit(:title, :description, :estimated_duration, :deadline, :time_sensitive, :start_time, :end_time)
  end
end
