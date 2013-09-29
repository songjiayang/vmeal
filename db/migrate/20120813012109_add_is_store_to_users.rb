class AddIsStoreToUsers < ActiveRecord::Migration
  def change
    add_column :users, :is_store, :integer ,:default =>0
  end
end
