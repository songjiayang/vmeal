class CreateComplaintReplies < ActiveRecord::Migration
  def change
    create_table :complaint_replies do |t|
      t.integer :super_man_id
      t.integer :complaint_id
      t.string :content

      t.timestamps
    end
  end
end
