class CreateFavorites < ActiveRecord::Migration
  def change
    create_table :favorites do |t|
      t.integer :user_id
      t.integer :store_id
      t.timestamps
    end
  end
  def self.down
    drop_table :favorites
  end
end
