class Item < ActiveRecord::Base
	belongs_to :merchant
	belongs_to :category
	has_and_belongs_to_many :wishlists
	validates_associated :merchant, :category
	validates :title, :merchant_id, :category_id, :presence => true
	validates :price, numericality: true, :allow_nil => true
	validates :image_url, :link, :format => {:with => /https?:\/\//, :message => 'Invalid URL format'}, :allow_blank => true
	validates :description, length: {maximum: 500}
end
