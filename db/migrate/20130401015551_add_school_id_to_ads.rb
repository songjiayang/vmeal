#encoding:utf-8
class AddSchoolIdToAds < ActiveRecord::Migration
  def change
    add_column :ads, :school_id, :integer
  end
end
