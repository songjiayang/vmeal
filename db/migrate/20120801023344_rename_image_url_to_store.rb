class RenameImageUrlToStore < ActiveRecord::Migration
  def up
    rename_column :stores , :image_url, :image_url_file_name
  end

  def down
    rename_column :stores , :image_url_file_name, :image_url
  end
end
