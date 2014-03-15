class ItemsController < ApplicationController
	def new
	end

	def show
		item_id = params[:id]
		@item = Item.find_by :id => item_id
	end

	def create_from_amazon
		i = Item.new
		amazon_url = params[:amazon_url]
		# All of the different possible Amazon url formats, 
		# thanks to http://en.wikipedia.org/wiki/Amazon_Standard_Identification_Number
		if /\/dp\/[A-Za-z0-9]{10}/.match(amazon_url).present?
			amazon_id = /\/dp\/([A-Za-z0-9]{10})/.match(amazon_url)[1]
		elsif /\/detail\/-\/[A-Za-z0-9]{10}/.match(amazon_url).present?
			amazon_id = /\/detail\/-\/([A-Za-z0-9]{10})/.match(amazon_url)[1]
		elsif /\/gp\/product\/[A-Za-z0-9]{10}/.match(amazon_url).present?
			amazon_id = /\/gp\/product\/([A-Za-z0-9]{10})/.match(amazon_url)[1]
		elsif /\/o\/ASIN\/[A-Za-z0-9]{10}/.match(amazon_url).present?
			amazon_id = /\/o\/ASIN\/([A-Za-z0-9]{10})/.match(amazon_url)[1]
		else
			amazon_id = nil
		end
		# Vacuum wrapper to the Amazon products API, https://github.com/hakanensari/vacuum
		req = Vacuum.new
		params = {
  			'IdType' => 'ASIN',
  			'ResponseGroup' => 'OfferSummary,Images,ItemAttributes,EditorialReview',
  			'ItemId' => amazon_id,
		}
		req.configure(
    		aws_access_key_id: AWS_KEY,
    		aws_secret_access_key: AWS_SECRET,
    		associate_tag: 'tag'
		)
		amazon_hash = req.item_lookup(params).to_h
		m = Merchant.find_by(:name => 'Amazon')
		i.merchant_id = m.id
		if amazon_hash['ItemLookupResponse']['Items']['Request']['Errors'].present?
			flash[:warning] = 'There was a problem with the lookup. Check the ID and try again.'
			redirect_to new_item_url
			return
		else
			original_category = amazon_hash['ItemLookupResponse']['Items']['Item']['ItemAttributes']['ProductGroup']
			category = [original_category]
			category << original_category + 's'
			category << original_category + 'es'
			category << original_category[0, category.length - 2] + 'ies'
			c = Category.find_by(:name => category)
			if c.nil?
				i.category_id = Category.find_by(:name => "Other").id
			else
				i.category_id = c.id
			end
			i.title = amazon_hash['ItemLookupResponse']['Items']['Item']['ItemAttributes']['Title']
			i.link = amazon_url
			if amazon_hash['ItemLookupResponse']['Items']['Item']['LargeImage'].present?
				i.image_url = amazon_hash['ItemLookupResponse']['Items']['Item']['LargeImage']['URL']
			end
			if amazon_hash['ItemLookupResponse']['Items']['Item']['OfferSummary'].present? and amazon_hash['ItemLookupResponse']['Items']['Item']['OfferSummary']['LowestNewPrice'].present?
				price_in_cents = amazon_hash['ItemLookupResponse']['Items']['Item']['OfferSummary']['LowestNewPrice']['Amount']
				i.price = price_in_cents.to_f/100
			end
			reviews = amazon_hash['ItemLookupResponse']['Items']['Item']['EditorialReviews']
			if reviews.nil?
				description = ''
			elsif reviews['EditorialReview'].is_a?(Array)
				description = reviews['EditorialReview'][0]['Content']
			else
				description = reviews['EditorialReview']['Content']
				description = ActionController::Base.helpers.strip_tags(description)
			end
			if description.length >= 490
				description = description[0,489] + '...'
			end
			i.description = description
		end
		if i.save
			flash[:notice] = 'Item added'
			redirect_to merchant_path(i.merchant_id)
		else
			flash[:warning] = ''
      		for error in i.errors.full_messages
        		flash[:warning] += error + '<br>'
      		end
			redirect_to new_item_url
		end
	end

	def create
		i = Item.new
		i.title = params[:title]
		i.link = params[:link]
		i.price = params[:price]
		i.description = params[:description]
		i.image_url = params[:image_url]
		merchant_id = params[:item][:merchant_id]
		i.category_id = params[:item][:category_id]
		i.merchant_id = merchant_id
		if i.save
			redirect_to merchant_path(merchant_id)
		else
			flash[:warning] = ''
      		for error in i.errors.full_messages
        		flash[:warning] += error + '<br>'
      		end
			redirect_to new_item_url
		end
	end	

	def edit
		item_id = params[:id]
		@item = Item.find_by(:id => item_id)
	end

	def update
		item_id = params[:id]
		merchant_id = params[:item][:merchant_id]
		i = Item.find_by(:id => item_id)
		i.merchant_id = merchant_id
		i.category_id = params[:item][:category_id]
		i.title = params[:title]
		i.link = params[:link]
		i.price = params[:price]
		i.description = params[:description]
		i.image_url = params[:image_url]
		if i.save
			redirect_to merchant_path(merchant_id)
		else
			flash[:warning] = ''
      		for error in i.errors.full_messages
        		flash[:warning] += error + '<br>'
      		end
			redirect_to edit_item_path(item_id)
		end
	end

	def destroy
		item_id = params[:id]
		i = Item.find_by(:id => item_id)
		merchant_id = i.merchant_id
    	i.destroy
	  	redirect_to merchant_path(merchant_id)
	end
end