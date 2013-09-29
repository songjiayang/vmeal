class AddImageUrlFileNameToUser < ActiveRecord::Migration
  def change
    add_column :users, :image_url_file_name, :string

  end
end
