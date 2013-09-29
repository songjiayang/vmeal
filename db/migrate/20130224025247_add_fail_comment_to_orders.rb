class AddFailCommentToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :fail_comment, :string
  end
end
