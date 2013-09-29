class AddImageUrlFileNameToVmealCategore < ActiveRecord::Migration
  def change
    add_column :vmeal_categores, :image_url_file_name, :string 
  end
end
