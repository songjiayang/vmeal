class AddHasRepliedToComplaints < ActiveRecord::Migration
  def change
    add_column :complaints, :has_replied, :integer 
  end
end
