require "google_utils"
class UsersController < ApplicationController

  def create
    user = User.new(user_parameters)
    user.google_url = GoogleUtils.new_spreadsheet_for(user.name)

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
