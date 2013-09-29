class AddTypeToFoodSenter < ActiveRecord::Migration
  def change
    add_column :food_senters, :user_type, :integer ,:defualt =>0

  end
end
