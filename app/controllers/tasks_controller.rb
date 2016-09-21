class TasksController < ApplicationController
  def index
    render json: User.find(params[:user_id]).tasks
  end
end
