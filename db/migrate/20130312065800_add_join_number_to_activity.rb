class AddJoinNumberToActivity < ActiveRecord::Migration
  def change
    add_column :activities, :join_number, :integer, :default=>0
    add_column :activities, :start_time, :datetime
    add_column :activities, :is_locked, :integer, :default=>0
  end
end
