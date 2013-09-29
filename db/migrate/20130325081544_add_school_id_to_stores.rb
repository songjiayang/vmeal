class AddSchoolIdToStores < ActiveRecord::Migration
  def change
    add_column :stores, :school_id, :integer
  end
end
