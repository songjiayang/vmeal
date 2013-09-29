class CreateMailIndexUsers < ActiveRecord::Migration
  def change
    create_table :mail_index_users do |t|
      t.integer :send_user_id
      t.integer :receiver_user_id
      t.integer :mail_id
      t.integer :send_status ,:default => 0
      t.integer :receive_status ,:default => 0
      t.integer :read_status ,:default => 0

      t.timestamps
    end
  end
end
