class CreateSendAddresses < ActiveRecord::Migration
  def change
    create_table :send_addresses do |t|
      t.string :address
      t.string :tel_number1
      t.string :tel_number2
      t.references :user

      t.timestamps
    end
    add_index :send_addresses, :user_id
  end
end
