class CreateCarts < ActiveRecord::Migration
  def self.up
    create_table :carts do |t|

      t.timestamps
    end
  end
  
  def self.dwon
    drop_teble :carts
  end
end
