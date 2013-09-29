class AddVmealCategoryNameToFood < ActiveRecord::Migration
  def change
    add_column :foods, :vmeal_category_name, :string
  end
end
