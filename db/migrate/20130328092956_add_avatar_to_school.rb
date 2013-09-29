class AddAvatarToSchool < ActiveRecord::Migration
  def change
  	add_attachment :schools, :avatar
  end
end
