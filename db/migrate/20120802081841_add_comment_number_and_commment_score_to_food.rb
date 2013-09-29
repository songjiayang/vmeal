class AddCommentNumberAndCommmentScoreToFood < ActiveRecord::Migration
  def change
    
    add_column :foods, :comment_number, :integer , :default =>1

    add_column :foods, :comment_score, :integer , :default =>4 

  end
end
