class CreateFoodSenters < ActiveRecord::Migration
  def change
    create_table :food_senters do |t|
      t.string :login_name
      t.string :password
      t.string :user_name
      t.string :id_number
      t.string :tel

      t.timestamps
    end
  end
end
