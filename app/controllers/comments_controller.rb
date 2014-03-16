class CommentsController < ApplicationController
	before_action :authorized_user, only: [:edit, :update, :destroy]
	def create
		c = Comment.new
		this_wishlist_id = params['wishlist_id']
		c.content = params['content']
		c.user_id = params['user_id']
		c.wishlist_id = this_wishlist_id
		if c.save
			flash[:notice] = 'Comment added'
			redirect_to wishlist_path(this_wishlist_id)
		else
			flash[:warning] = 'There was a problem saving your comment'
			if Wishlist.find_by(:id => this_wishlist_id).present?
				redirect_to wishlist_path(this_wishlist_id)
			else
				redirect_to wishlists_url
			end
		end
	end

	def edit
		this_wishlist_id = params[:wishlist_id]
		this_comment_id = params[:id]
		@comment = Comment.find_by(:id => this_comment_id)
		@wishlist = Wishlist.find_by(:id => this_wishlist_id)
	end

	def update
		this_wishlist_id = params[:wishlist_id]
		this_comment_id = params[:id]
		c = Comment.find_by(:id => this_comment_id)
		c.content = params[:content]
		if c.save
			redirect_to wishlist_path(this_wishlist_id)
		else 
			flash[:warning] = 'There was a problem saving your comment'
			if Wishlist.find_by(:id => this_wishlist_id).present?
				redirect_to wishlist_path(this_wishlist_id)
			else
				redirect_to wishlists_url
			end
		end
	end

	def destroy
		this_wishlist_id = params[:wishlist_id]
		this_comment_id = params[:id]
		c = Comment.find_by(:id => this_comment_id)
    	c.destroy
	  	redirect_to wishlist_path(this_wishlist_id)
	end
	private
	def authorized_user
		this_comment_id = params[:id]
		comment = Comment.find_by(:id => this_comment_id)
		unless comment.user_id == session[:user_id]
			flash[:alert] = "You don't have permission to do that"
			redirect_to wishlists_url
		end
	end
end