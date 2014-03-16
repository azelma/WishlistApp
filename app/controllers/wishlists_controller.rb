class WishlistsController < ApplicationController
	before_action :authorized_users 
	skip_before_action :authorized_users, only: [:new, :create, :index, :show]

	def new
	end

	def show
		this_wishlist_id = params[:id]
		this_user_id = session[:user_id]
		# Doesn't use authorized user filter since more users can view than can perform other actions
		authorized_users = Membership.where(:wishlist_id => this_wishlist_id).pluck(:user_id)
		if authorized_users.include?(this_user_id)
			membership_info = Membership.find_by(:wishlist_id => this_wishlist_id, :user_id => this_user_id)
			@is_contributor = membership_info.contributor
			@wishlist = Wishlist.find_by(:id => this_wishlist_id)
			@items = @wishlist.items
			@user = User.find_by(:id => this_user_id)
		else
			flash[:alert] = "You don't have permission to view that list"
			redirect_to "/"
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
				redirect_to "/"
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
		@wishlist = Wishlist.find_by(:id => this_wishlist_id)
	end

	def update
		this_wishlist_id = params[:id]
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
	end

	def destroy
		this_wishlist_id = params[:id]
		w = Wishlist.find_by(:id => this_wishlist_id)
    	w.destroy
	  	redirect_to "/"
	end

	def additem
		this_wishlist_id = params[:wishlist_id]
		this_item_id = params[:item_id]
		w = Wishlist.find_by(:id => this_wishlist_id)
		i = Item.find_by(:id => this_item_id)
		if w and i
			w.items << i
			redirect_to wishlist_path(this_wishlist_id)
		else
			flash[:warning] = 'There was an error adding that item'
			if w.nil?
				redirect_to "/"
			else
				redirect_to wishlist_path(this_wishlist_id)
			end
		end
	end

	def removeitem
		this_wishlist_id = params[:wishlist_id]
		this_item_id = params[:item_id]
		w = Wishlist.find_by(:id => this_wishlist_id)
		i = Item.find_by(:id => this_item_id)
		w.items.delete(i)
		redirect_to wishlist_path(this_wishlist_id)
	end

	private
	def authorized_users
		if params[:wishlist_id]
			this_wishlist_id = params[:wishlist_id]
		else
			this_wishlist_id = params[:id]
		end
		authorized_users = Membership.where(:wishlist_id => this_wishlist_id).where(:contributor=>true).pluck(:user_id)
		unless authorized_users.include?(session[:user_id])
			flash[:alert] = "You don't have permission to do that"
			redirect_to "/"
		end
	end
end