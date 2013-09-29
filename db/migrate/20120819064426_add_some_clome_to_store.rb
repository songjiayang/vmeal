class AddSomeClomeToStore < ActiveRecord::Migration
  def change
    add_column :stores, :main_sales, :string
    add_column :stores, :public_talk, :string
  end
end
