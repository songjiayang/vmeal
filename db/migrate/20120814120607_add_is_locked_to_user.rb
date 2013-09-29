class AddIsLockedToUser < ActiveRecord::Migration
  def change
    add_column :users, :is_locked, :integer , :default =>0
  end
end
