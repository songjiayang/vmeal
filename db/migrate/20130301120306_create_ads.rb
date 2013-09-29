class CreateAds < ActiveRecord::Migration
  def change
    create_table :ads do |t|
      t.string :img_path
      t.string :link_to, :default=>"/"
      t.integer :ad_type, :default=>1
      t.integer :order_number, :default=>0
      t.time :expiration_time
      t.integer :money, :default=>0
      t.timestamps
    end
  end
end
