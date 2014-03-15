class Merchant < ActiveRecord::Base
	has_many :items
	validates :name, presence: true, uniqueness: true
	validates :site, :format => {:with => /https?:\/\//, :message => 'Invalid URL format'}, :allow_blank => true
	before_destroy { |record| Item.destroy_all "merchant_id = #{record.id}"   }
end