class MerchantsController < ApplicationController
	def index
		@merchants = Merchant.all.order('name desc')
		this_user_id = session[:user_id]
		wishlist_ids = Membership.where(:user_id => this_user_id).where(:contributor=>true).pluck(:wishlist_id)
		@wishlists = Wishlist.where(:id => wishlist_ids)
	end

	def new
	end

	def show
		merchant_id = params[:id]
		this_user_id = session[:user_id]
		wishlist_ids = Membership.where(:user_id => this_user_id).where(:contributor=>true).pluck(:wishlist_id)
		@merchant = Merchant.find_by :id => merchant_id
		@items = @merchant.items
		@wishlists = Wishlist.where(:id => wishlist_ids)
	end

	def create
		m = Merchant.new
		m.name = params[:name]
		m.site = params[:site]
		if m.save
			flash[:notice] = 'Mechant added'
			redirect_to merchants_url
		else
			flash[:warning] = ''
      		for error in m.errors.full_messages
        		flash[:warning] += error + '<br>'
      		end
			redirect_to new_merchant_url
		end
	end	

	def edit
		merchant_id = params[:id]
		@merchant = Merchant.find_by(:id => merchant_id)
	end

	def update
		merchant_id = params[:id]
		m = Merchant.find_by(:id => merchant_id)
		m.name = params[:name]
		m.site = params[:site]
		if m.save
			flash[:notice] = 'Mechant updated'
			redirect_to merchants_url
		else
			flash[:warning] = ''
      		for error in m.errors.full_messages
        		flash[:warning] += error + '<br>'
      		end
			redirect_to edit_merchant_path(merchant_id)
		end
	end

	def destroy
		merchant_id = params[:id]
		m = Merchant.find_by(:id => merchant_id)
    	m.destroy
	  	redirect_to root_url
	end
end