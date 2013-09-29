class RemoveFavoritestoreFromUsers < ActiveRecord::Migration
  def up
    remove_column :users, :favoritestore
      end

  def down
    add_column :users, :favoritestore, :integer
  end
end
