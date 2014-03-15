class Category < ActiveRecord::Base
	has_many :items
	validates :name, presence: true, uniqueness: true
	before_destroy :update_categories
	before_destroy :check_for_other
	def update_categories
		other_category = Category.find_by(:name => "Other")
		Item.where(:category_id => id).update_all(category_id: other_category.id)
	end
	def check_for_other
		errors.add(:base, 'Cannot delete Other category') if name == 'Other'
	end
end
