#encoding: utf-8
class AddSendTimeToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :send_time, :string, :default => "立即送出"
  end
end
