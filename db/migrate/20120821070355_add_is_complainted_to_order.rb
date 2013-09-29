class AddIsComplaintedToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :is_complainted, :integer ,:default =>0

  end
end
