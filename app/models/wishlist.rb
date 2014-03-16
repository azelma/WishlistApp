class Wishlist < ActiveRecord::Base
	has_and_belongs_to_many :items
	has_many :comments
	has_many :memberships
    has_many :items
	has_many :users, through: :memberships

	validates_associated :items
	
    validates :name, presence: true
	
    before_destroy { |record| Membership.destroy_all "wishlist_id = #{record.id}"   }
	before_destroy { |record| Comment.destroy_all "wishlist_id = #{record.id}"   }
    before_destroy { |record| Item.destroy_all "wishlist_id = #{record.id}"   }

    scope :contributors
    scope :commenters
end