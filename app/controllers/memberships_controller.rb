class MembershipsController < ApplicationController

	def index
		this_user_id = session[:user_id]
		this_wishlist_id = params[:wishlist_id]
		members = Membership.where(:wishlist_id => this_wishlist_id)
		commenter_ids = members.where(:contributor=>false).pluck(:user_id)
		contributor_ids = members.where(:contributor=>true).pluck(:user_id) 
		@is_contributor = Membership.find_by(:wishlist_id => this_wishlist_id,:user_id => this_user_id).contributor
		@wishlist = Wishlist.find_by(:id => this_wishlist_id)
		@commenters = User.where(:id => commenter_ids)
		@contributors = User.where(:id => contributor_ids)
	end

	def new
		this_user_id = session[:user_id]
		this_wishlist_id = params[:wishlist_id]
		@contributor = Membership.find_by(:user_id => this_user_id, :wishlist_id => this_wishlist_id).contributor
	end

	def create
		m = Membership.new
		this_wishlist_id = params[:wishlist_id]
		m.wishlist_id = this_wishlist_id
		m.user_id = params[:wishlist][:user]
		m.contributor = params[:contributor]
		if m.save
			flash[:notice] = 'Membership added'
			redirect_to wishlist_memberships_path(this_wishlist_id)
		else
			flash[:warning] = ''
      		for error in m.errors.full_messages
        		flash[:warning] += error + '<br>'
      		end
			redirect_to new_wishlist_membership_path
		end
	end

	def destroy
		member_id = params[:id]
		wishlist_id = params[:wishlist_id]
		m = Membership.find_by(:wishlist_id => wishlist_id, :user_id => member_id)
    	m.destroy
	  	redirect_to wishlist_memberships_path(wishlist_id)
	end
end