class CreateShortPhones < ActiveRecord::Migration
  def change
    create_table :short_phones do |t|
      t.string :phone_number
      t.integer :store_id
      t.text :content

      t.timestamps
    end
  end
end
