class AddStoreNameToApplication < ActiveRecord::Migration
  def change
    add_column :applications, :store_name, :string
  end
end
