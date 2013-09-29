class AddSentTimeToFood < ActiveRecord::Migration
  def change
    add_column :foods, :sent_time, :integer ,:default => 18
  end
end
