class AddSomethingToActivities < ActiveRecord::Migration
  def change
  	remove_column  :activities, :avatar
  	add_attachment :activities, :avatar
  end
end
