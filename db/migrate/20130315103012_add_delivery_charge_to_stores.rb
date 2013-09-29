class AddDeliveryChargeToStores < ActiveRecord::Migration
  def change
    add_column :stores, :delivery_charge, :integer, :default => 0
  end
end
