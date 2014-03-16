class Membership < ActiveRecord::Base
	belongs_to :user
	belongs_to :wishlist

	validates_inclusion_of :contributor, :in =>[true, false]
	validates_uniqueness_of :user_id, :scope => :wishlist_id

    scope :contributing_lists, ->(user) { Wishlist.where(:id => Membership.where(:user_id => user.id, :contributor => true).pluck(:wishlist_id)) }
    scope :commenting_lists, ->(user) { Wishlist.where(:id => Membership.where(:user_id => user.id, :contributor => false).pluck(:wishlist_id)) }

    scope :contributing_users, ->(list) { User.where(:id => Membership.where(:wishlist_id => list.id, :contributor => true).pluck(:user_id)) }
    scope :commenting_users, ->(list) { User.where(:id => Membership.where(:wishlist_id => list.id, :contributor => false).pluck(:user_id)) }
end
