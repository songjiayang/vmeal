class AddDescribeToAds < ActiveRecord::Migration
  def change
    add_column :ads, :describe, :string
  end
end
