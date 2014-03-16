class Membership < ActiveRecord::Base
	belongs_to :user
	belongs_to :wishlist
	validates_inclusion_of :contributor, :in =>[true, false]
	validates_uniqueness_of :user_id, :scope => :wishlist_id
end
