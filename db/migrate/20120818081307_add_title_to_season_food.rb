class AddTitleToSeasonFood < ActiveRecord::Migration
  def change
    add_column :season_foods, :title, :string

  end
end
