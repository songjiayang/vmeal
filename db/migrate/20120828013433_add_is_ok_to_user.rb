class AddIsOkToUser < ActiveRecord::Migration
  def change
    add_column :users, :is_ok, :integer ,:default => 0

  end
end
