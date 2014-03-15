class PagesController < ApplicationController
	def home
		@categories = Category.all
		@merchants = Merchant.all
		@items = Item.all.order('created_at desc').limit(12)
		this_user_id = session[:user_id]
		@user = User.find_by(:id => this_user_id)
		if @user.nil?
			@wishlists = []
		else
			wishlist_ids = Membership.where(:user_id => this_user_id).where(:contributor=>true).pluck(:wishlist_id)
			@wishlists = Wishlist.where(:id => wishlist_ids)
		end
	end
end