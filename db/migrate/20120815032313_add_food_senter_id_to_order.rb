class AddFoodSenterIdToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :food_senter_id, :integer

  end
end
