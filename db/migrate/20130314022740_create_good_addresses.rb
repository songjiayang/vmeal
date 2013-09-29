class CreateGoodAddresses < ActiveRecord::Migration
  def change
    create_table :good_addresses do |t|
      t.string :real_name
      t.string :address
      t.string :tel_number
      t.string :zip_code
      t.integer :user_id

      t.timestamps
    end
  end
end
