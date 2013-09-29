class AddSalesCountToFood < ActiveRecord::Migration
  def change
    add_column :foods, :sales_count, :integer ,:default =>0

  end
end
