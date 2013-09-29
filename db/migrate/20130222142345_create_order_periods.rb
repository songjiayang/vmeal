class CreateOrderPeriods < ActiveRecord::Migration
  def change
    create_table :order_periods do |t|
      t.string  :start_time
      t.string  :end_time
      t.string  :description
      t.integer :max_number
      t.integer :store_id
      t.timestamps
    end
  end
end
