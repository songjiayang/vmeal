class CreateSuperMen < ActiveRecord::Migration
  def change
    create_table :super_men do |t|
      t.string :user_name ,:uniq=>true
      t.string :password  
      t.timestamps
    end
  end
end
