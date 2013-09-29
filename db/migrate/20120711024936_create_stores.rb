class CreateStores < ActiveRecord::Migration
  def self.up
    create_table :stores do |t|
      t.string :name
      t.string :introduce
      t.string :address
      t.time :opentime
      t.time :closetime
      t.string :tags
      t.string :categore
      t.string :tel
      t.integer :isclose
      t.decimal :send_price, :precision => 6, :scale =>2
      t.decimal :rank
      t.timestamp :settledtime

      t.timestamps
    end
  end
  
  def self.down
    drop_table :stores
  end
end
