class Comment < ActiveRecord::Base
	belongs_to :wishlist
	belongs_to :user
	
    validate :has_permission
	
    def has_permission
		authorized = Membership.find_by(:wishlist_id => wishlist_id, :user_id => user_id, :contributor => false)
		errors.add(:base, 'Must have permission to comment') if authorized.blank?
	end
end
