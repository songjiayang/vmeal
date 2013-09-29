class AddPhoneBkToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :phone_bk, :string

  end
end
