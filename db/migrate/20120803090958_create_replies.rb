class CreateReplies < ActiveRecord::Migration
  def change
    create_table :replies do |t|
      t.string :comment
      t.integer :message_id

      t.timestamps
    end
  end
end
