class CreateComplaints < ActiveRecord::Migration
  def change
    create_table :complaints do |t|
      t.integer :user_id
      t.string :order_number
      t.string :target
      t.string :content
      t.timestamps
    end
  end
end
