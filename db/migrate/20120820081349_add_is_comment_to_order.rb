class AddIsCommentToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :is_comment, :integer ,:default =>0
  end
end
