class AddPhotoToFood < ActiveRecord::Migration
  def change
    add_column :foods, :photo_file_name, :string
  end
end
