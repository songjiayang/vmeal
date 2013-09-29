class AddSentTimeToStores < ActiveRecord::Migration
  def change
    add_column :stores, :sent_time, :integer ,:default => 20
 
  end
end
