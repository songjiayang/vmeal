#encoding : utf-8
class ChangePayTypeToOrders < ActiveRecord::Migration
  def change
    change_column_default(:orders, :pay_type, "货到付款")
  end
end
