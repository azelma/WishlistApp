class PagesController < ApplicationController
	def home
		this_user_id = session[:user_id]
		@current_user = User.find_by(:id => this_user_id)
	end
end