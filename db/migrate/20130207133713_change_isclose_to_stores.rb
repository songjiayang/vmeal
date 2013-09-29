class ChangeIscloseToStores < ActiveRecord::Migration
  def up
    change_column :stores, :isclose, :integer, :default => 0
  end

  def down
    change_column :stores, :isclose, :integer
  end
end
