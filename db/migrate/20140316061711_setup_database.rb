class SetupDatabase < ActiveRecord::Migration
  def change
  	create_table "categories", force: true do |t|
	    t.string   "name"

	    t.timestamps
	  end

	create_table "comments", force: true do |t|
	    t.text     "content"
	    t.integer  "wishlist_id"
	    t.integer  "user_id"

		t.timestamps
	end

	create_table "items", force: true do |t|
	    t.string   "title"
	    t.text     "description"
	    t.float    "price"
	    t.string   "link"
	    t.string   "image_url"
	    t.integer  "merchant_id"
	    t.integer  "category_id"

	    t.timestamps
	end

	create_table "items_wishlists", id: false, force: true do |t|
	    t.integer "item_id"
	    t.integer "wishlist_id"
	end

	create_table "memberships", force: true do |t|
	    t.integer "user_id"
	    t.integer "wishlist_id"
	    t.boolean "contributor"
	end

	create_table "merchants", force: true do |t|
	    t.string   "name"
	    t.string   "site"

	    t.timestamps
	end

	create_table "users", force: true do |t|
	    t.string   "name"
	    t.string   "password_digest"

	    t.timestamps
	end

	create_table "wishlists", force: true do |t|
	    t.string   "name"
	    t.text     "description"

	    t.timestamps
	end
  end
end
