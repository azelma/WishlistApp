class CategoriesController < ApplicationController
	def index
		this_user_id = session[:user_id]
		wishlist_ids = Membership.where(:user_id => this_user_id).where(:contributor=>true).pluck(:wishlist_id)
		@wishlists = Wishlist.where(:id => wishlist_ids)
		@categories = Category.all.order('name asc')
	end

	def show
		this_user_id = session[:user_id]
		wishlist_ids = Membership.where(:user_id => this_user_id).where(:contributor=>true).pluck(:wishlist_id)
		@wishlists = Wishlist.where(:id => wishlist_ids)
		category_id = params[:id]
		@category = Category.find_by(:id => category_id)
		@items = @category.items
	end

	def edit
		this_category_id = params[:id]
		@category = Category.find_by(:id => this_category_id)
	end

	def update
		this_category_id = params[:id]
		c = Category.find_by(:id => this_category_id)
		c.name = params[:name]
		if c.save
			flash[:notice] = 'Category sucessfully updated'
			redirect_to category_path(this_category_id)
		else
			flash[:warning] = ''
      		for error in c.errors.full_messages
        		flash[:warning] += error + '<br>'
      		end
			redirect_to edit_category_path(this_category_id)
		end
	end

	def destroy
		this_category_id = params[:id]
		c = Category.find_by(:id => this_category_id)
    	c.destroy
	  	redirect_to categories_url
	end
end