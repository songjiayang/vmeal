class AddFavoritestoreToUsers < ActiveRecord::Migration
  def change
     add_column  :users, :favoritestore, :Integer
  end
end
