class AddNameToSendAddresses < ActiveRecord::Migration
  def change
    add_column :send_addresses, :name, :string
  end
end
