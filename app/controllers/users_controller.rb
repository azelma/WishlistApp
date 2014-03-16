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

  def edit
    @user = User.find(session[:user_id])
    redirect_to new_user_url unless @user
  end

  def update
    u = User.find(params[:id])
    u.password = params[:password]
    u.password_confirmation = params[:password_confirmation]
    if u.save
      flash[:notice] = 'Password changed.'
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