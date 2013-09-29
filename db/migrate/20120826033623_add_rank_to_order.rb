class AddRankToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :rank, :integer ,:defalut =>4

  end
end
