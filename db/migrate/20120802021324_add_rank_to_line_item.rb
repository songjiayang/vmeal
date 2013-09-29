class AddRankToLineItem < ActiveRecord::Migration
  def change
    add_column :line_items, :rank, :integer ,:default =>3
  end
end
