class CreatePeakOrderPeriods < ActiveRecord::Migration
  def change
    create_table :peak_order_periods do |t|
      t.time :start_time
      t.time :end_time
      t.integer :order_period_id
      t.integer :max_number

      t.timestamps
    end
  end
end
