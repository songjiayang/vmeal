class RenameTypeToRoleToAdmins < ActiveRecord::Migration
  def up
  	rename_column :admins, :type, :role
  end

  def down
  	rename_column :admins,  :role, :type
  end
end
