class UsersController < ApplicationController
  def new
  end

  def create
  	u = User.new
    u.name = params[:name]
    u.password = params[:password]
    u.password_confirmation = params[:password_confirmation]
    if u.save
      session[:user_id] = u.id
      flash[:notice] = 'Thanks for signing up!'
      redirect_to root_url
    else
      flash[:warning] = ''
      for error in u.errors.full_messages
        flash[:warning] += error + '<br>'
      end
      redirect_to new_user_url
    end
  end
end