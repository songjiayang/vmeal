class AddSumCommentToStore < ActiveRecord::Migration
  def change
    add_column :stores, :sum_comment, :integer ,:default =>1

    add_column :stores, :sum_score, :integer, :default =>4

  end
end
