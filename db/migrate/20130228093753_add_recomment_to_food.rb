class AddRecommentToFood < ActiveRecord::Migration
  def change
    add_column :foods, :is_recommend, :int,:default => 0
    add_column :foods, :recomment_description, :string
  end
end
