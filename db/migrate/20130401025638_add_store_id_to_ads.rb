class AddStoreIdToAds < ActiveRecord::Migration
  def change
    add_column :ads, :store_id, :integer
  end
end
