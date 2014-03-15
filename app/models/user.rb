class User < ActiveRecord::Base
	has_secure_password
	has_many :users
	has_many :memberships
	has_many :wishlists, through: :memberships
	validates :name, presence: true, uniqueness: true
	before_destroy { |record| Membership.destroy_all "user_id = #{record.id}" }
end