class User < ActiveRecord::Base
	has_secure_password

	has_many :memberships
	has_many :wishlists, through: :memberships
	
    validates :name, presence: true, uniqueness: true
	
    def contributing_lists
        Membership.contributing_lists(self)
    end

    def commenting_lists
        Membership.commenting_lists(self)
    end

    before_destroy { |record| Membership.destroy_all "user_id = #{record.id}" }
end