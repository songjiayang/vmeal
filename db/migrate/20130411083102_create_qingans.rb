class CreateQingans < ActiveRecord::Migration
  def change
    create_table :qingans do |t|
      t.string :name
      t.string :telephone

      t.timestamps
    end
  end
end
