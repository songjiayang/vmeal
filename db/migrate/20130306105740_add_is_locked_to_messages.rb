class AddIsLockedToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :is_locked, :integer, :default=>0  
  end
end
