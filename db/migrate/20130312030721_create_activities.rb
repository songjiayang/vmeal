class CreateActivities < ActiveRecord::Migration
  def change
    create_table :activities do |t|
      t.string :title
      t.integer :need_score, :default => 0 
      t.decimal :real_money, :precision => 8, :scale => 1 
      t.integer :total_number, :default => 0
      t.datetime :end_time
      t.string :avatar
      t.string :description

      t.timestamps
    end
  end
end
