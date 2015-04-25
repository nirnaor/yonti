class UsersController < ApplicationController

  def create
    user = User.new(user_parameters)
    if user.save
      render json: user
    else
      render json: user.errors, :status => :unprocessable_entity
    end
  end

  def user_parameters
    params.require(:user).permit(:name, :password, :password_confimation)
  end

end
