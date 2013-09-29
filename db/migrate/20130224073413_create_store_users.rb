class CreateStoreUsers < ActiveRecord::Migration
  def change
    create_table :store_users do |t|
      t.string :username
      t.string :password
      t.integer :store_id

      t.timestamps
    end
  end
end
