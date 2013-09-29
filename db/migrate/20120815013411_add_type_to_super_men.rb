class AddTypeToSuperMen < ActiveRecord::Migration
  def change
    add_column :super_men, :user_type, :integer ,:default => 0
  end
end
