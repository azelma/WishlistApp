class SessionsController < ApplicationController
  def destroy
    reset_session
    redirect_to root_url, notice: "Goodbye."
  end

  def create
    username = params[:name]

    user = User.find_by(name: username)
    if user and user.authenticate(params[:password])
      session[:user_id] = user.id
      flash[:notice] = "Welcome Back, #{user.name}"
      redirect_to root_url
    else
      flash[:warning] = "Unknown username or password"
      redirect_to new_session_url 
    end
  end
end