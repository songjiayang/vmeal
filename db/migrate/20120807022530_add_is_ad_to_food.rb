class AddIsAdToFood < ActiveRecord::Migration
  def change
    add_column :foods, :is_ad, :integer ,:default =>0
  end
end
