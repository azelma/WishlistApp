class RemoveMerchantsAddWishlistId < ActiveRecord::Migration
  def change
    drop_table "items_wishlists"
    drop_table "merchants"

    add_column "items", "wishlist_id", :integer
  end
end
