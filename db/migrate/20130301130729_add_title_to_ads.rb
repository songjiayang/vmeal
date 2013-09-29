class AddTitleToAds < ActiveRecord::Migration
  def change
    add_column :ads, :title, :string, :default=>""
    add_column :ads, :status, :string, :default=>""
  end
end
