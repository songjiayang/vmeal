class CreateScoreHistories < ActiveRecord::Migration
  def change
    create_table :score_histories do |t|
      t.integer :user_id
      t.string :operate
      t.string :detail
      t.integer :change_score, :default=>0
      t.integer :change_type, :default=>0 
      t.integer :activity_id
      t.timestamps
    end
    add_index :score_histories, :change_type
  end
end
