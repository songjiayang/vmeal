class CreateOrders < ActiveRecord::Migration
  def self.up
    create_table :orders do |t|
      t.string :address
      t.string :phone
      t.string :name
      t.string :order_number
      t.string :pay_type
      t.timestamps
    end
  end
  
   def self.down
     drop_table :orders 
  end
  
end
