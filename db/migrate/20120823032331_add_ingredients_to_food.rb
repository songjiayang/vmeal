class AddIngredientsToFood < ActiveRecord::Migration
  def change
    add_column :foods, :ingredients, :string
  end
end
