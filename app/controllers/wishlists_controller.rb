class WishlistsController < ApplicationController

	def index
		this_user_id = session[:user_id]
		membership_info = Membership.where(:user_id => this_user_id)
		contributor_lists = membership_info.where(:contributor=>true).pluck(:wishlist_id)
		commenter_lists = membership_info.where(:contributor=>false).pluck(:wishlist_id)
		@contributing_lists = Wishlist.where(:id => contributor_lists)
		@commenting_lists = Wishlist.where(:id => commenter_lists)
	end

	def new
	end

	def show
		this_wishlist_id = params[:id]
		this_user_id = session[:user_id]
		authorized_users = Membership.where(:wishlist_id => this_wishlist_id).pluck(:user_id)
		if authorized_users.include?(this_user_id)
			membership_info = Membership.find_by(:wishlist_id => this_wishlist_id, :user_id => this_user_id)
			@is_contributor = membership_info.contributor
			@wishlist = Wishlist.find_by(:id => this_wishlist_id)
			@items = @wishlist.items
			@user = User.find_by(:id => this_user_id)
		else
			flash[:alert] = "You don't have permission to view that list"
			redirect_to wishlists_url
		end
	end

	def create
		w = Wishlist.new
		w.name = params[:name]
		w.description = params[:description]
		if w.save
			m = Membership.new
			m.user_id = session[:user_id]
			m.wishlist_id = w.id
			m.contributor = true
			if m.save
				redirect_to wishlists_url
			else
				w.destroy
				flash[:warning] = ''
      			for error in m.errors.full_messages
        			flash[:warning] += error + '<br>'
      			end
				redirect_to new_wishlist_url
			end
		else
			flash[:warning] = ''
      		for error in w.errors.full_messages
        		flash[:warning] += error + '<br>'
     		 end
			redirect_to new_wishlist_url
		end
	end	

	def edit
		this_wishlist_id = params[:id]
		authorized_users = Membership.where(:wishlist_id => this_wishlist_id).where(:contributor=>true).pluck(:user_id)
		if authorized_users.include?(session[:user_id])
			@wishlist = Wishlist.find_by(:id => this_wishlist_id)
		else
			flash[:alert] = "You don't have permission to edit that list"
			redirect_to wishlists_url
		end
	end

	def update
		this_wishlist_id = params[:id]
		authorized_users = Membership.where(:wishlist_id => this_wishlist_id).where(:contributor=>true).pluck(:user_id)
		if authorized_users.include?(session[:user_id])
			w = Wishlist.find_by(:id => this_wishlist_id)
			w.name = params[:name]
			w.description = params[:description]
			if w.save
				redirect_to wishlist_path(this_wishlist_id)
			else
				flash[:warning] = ''
      			for error in w.errors.full_messages
        			flash[:warning] += error + '<br>'
      			end
				redirect_to edit_wishlist_path(this_wishlist_id)
			end
		else
			flash[:alert] = "You don't have permission to edit that list"
			redirect_to wishlists_url
		end
	end

	def destroy
		this_wishlist_id = params[:id]
		authorized_users = Membership.where(:wishlist_id => this_wishlist_id).where(:contributor=>true).pluck(:user_id)
		if authorized_users.include?(session[:user_id])
			w = Wishlist.find_by(:id => this_wishlist_id)
    		w.destroy
	  		redirect_to wishlists_url
	  	else
	  		flash[:alert] = "You don't have permission to delete that list"
	  		redirect_to wishlists_url
	  	end
	end

	def additem
		this_wishlist_id = params[:wishlist_id]
		authorized_users = Membership.where(:wishlist_id => this_wishlist_id).where(:contributor=>true).pluck(:user_id)
		if authorized_users.include?(session[:user_id])
			this_item_id = params[:item_id]
			w = Wishlist.find_by(:id => this_wishlist_id)
			i = Item.find_by(:id => this_item_id)
			if w and i
				w.items << i
				redirect_to wishlist_path(this_wishlist_id)
			else
				flash[:warning] = 'There was an error adding that item'
				if w.nil?
					redirect_to wishlists_url
				else
					redirect_to wishlist_path(this_wishlist_id)
				end
			end
		else
			flash[:alert] = "You don't have permission to add items to that list"
			redirect_to wishlists_url
		end
	end

	def removeitem
		this_wishlist_id = params[:wishlist_id]
		authorized_users = Membership.where(:wishlist_id => this_wishlist_id).where(:contributor=>true).pluck(:user_id)
		if authorized_users.include?(session[:user_id])
			this_item_id = params[:item_id]
			w = Wishlist.find_by(:id => this_wishlist_id)
			i = Item.find_by(:id => this_item_id)
			w.items.delete(i)
			redirect_to wishlist_path(this_wishlist_id)
		else
			flash[:alert] = "You don't have permission to delete items from that list"
			redirect_to wishlists_url
		end
	end
end