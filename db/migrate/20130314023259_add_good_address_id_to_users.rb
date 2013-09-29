class AddGoodAddressIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :good_address_id, :integer
  end
end
