class CreateExchangeGoods < ActiveRecord::Migration
  def change
    create_table :exchange_goods do |t|
      t.string :name
      t.string :image_url_file_name
      t.integer :least_integral

      t.timestamps
    end
  end
end
