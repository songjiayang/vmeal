class AddIsWorkToFoodSenter < ActiveRecord::Migration
  def change
    add_column :food_senters, :is_work, :integer ,:defult =>0
  end
end
