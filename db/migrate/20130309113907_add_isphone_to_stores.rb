class AddIsphoneToStores < ActiveRecord::Migration
  def change
    add_column :stores, :isphone, :integer, :default => 0
    add_column :stores, :sortvalue, :integer, :default => 0
  end
end
