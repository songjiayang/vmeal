class CreateFoods < ActiveRecord::Migration
  def self.up
    create_table :foods do |t|
      t.string :name
      t.float :price
      t.integer :sum
      t.string :tag
      t.integer :energy
      t.float :rank
      t.float :sales
      t.references :store
      t.references :category

      t.timestamps
    end
    add_index :foods, :store_id
    add_index :foods, :category_id
  end
  
  def self.down
    drop_table :foods
  end
end
