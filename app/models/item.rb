class Item < ActiveRecord::Base
	belongs_to :category
	belongs_to :wishlist

	validates_associated :category
    
	validates :title, :category_id, :presence => true
	validates :price, numericality: true, :allow_nil => true
	validates :image_url, :link, :format => {:with => /https?:\/\//, :message => 'Invalid URL format'}, :allow_blank => true
	validates :description, length: {maximum: 500}
end
