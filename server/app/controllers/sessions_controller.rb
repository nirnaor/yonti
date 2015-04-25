class SessionsController < ApplicationController
  def create
    user = User.find_by_name(params[:name])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      render json: {logged_in: true}
    else
      render json: {}, :status => :unauthorized
    end
  end
end
