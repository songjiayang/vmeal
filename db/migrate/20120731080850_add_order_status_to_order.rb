class AddOrderStatusToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :order_status, :integer, :default => 0

  end
end
