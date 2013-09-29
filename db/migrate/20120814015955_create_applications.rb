class CreateApplications < ActiveRecord::Migration
  def change
    create_table :applications do |t|
      t.string :tel
      t.string :user_name
      t.string :address
      t.text :about_store
      t.integer :status ,:default =>0
      t.references :user
      t.timestamps
    end
    add_index :applications, :user_id
  end
end
