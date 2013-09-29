class AddDefaultAddressIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :default_address_id, :integer, :default => -1
  end
end
