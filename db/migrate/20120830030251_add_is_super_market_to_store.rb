class AddIsSuperMarketToStore < ActiveRecord::Migration
  def change
    add_column :stores, :is_super_market, :integer ,:default =>0

  end
end
