class CreateVmails < ActiveRecord::Migration
  def change
    create_table :vmails do |t|
      t.string :title
      t.text :content
      t.string :sent_mails
      t.integer :admin_id
      t.integer :is_send, :defult=>0

      t.timestamps
    end
  end
end
