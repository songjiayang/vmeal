class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.string :comment
      t.integer :user_id
      t.integer :store_id

      t.timestamps
    end
  end
end
