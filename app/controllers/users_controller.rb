class UsersController < ApplicationController
  def create
    render json: User.find_or_create_by(user_params)
  end

  private
  def user_params
    params.require(:user).permit(:name)
  end
end
