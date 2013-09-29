class RenameImageUrlToSeasonFood < ActiveRecord::Migration
  def up
    rename_column :season_foods , :image_url, :image_url_file_name
  end

  def down
    rename_column :season_foods , :image_url_file_name, :image_url
  end
end
