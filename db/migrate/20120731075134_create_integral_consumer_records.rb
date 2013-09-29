class CreateIntegralConsumerRecords < ActiveRecord::Migration
  def change
    create_table :integral_consumer_records do |t|
      t.integer :user_id
      t.integer :exchange_goods_id
      t.integer :number

      t.timestamps
    end
  end
end
