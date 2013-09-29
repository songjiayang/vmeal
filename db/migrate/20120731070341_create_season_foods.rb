class CreateSeasonFoods < ActiveRecord::Migration
  def change
    create_table :season_foods do |t|
      t.string :image_url
      t.string :introduction
      t.text :content
      t.timestamps
    end
  end
end
