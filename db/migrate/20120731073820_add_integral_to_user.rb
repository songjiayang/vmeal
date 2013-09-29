class AddIntegralToUser < ActiveRecord::Migration
  def change
    add_column :users, :integral, :integer ,:default=>0
  end
end
