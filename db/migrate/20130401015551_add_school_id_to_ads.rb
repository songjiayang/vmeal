#encoding:utf-8
class AddSchoolIdToAds < ActiveRecord::Migration
  def change
    add_column :ads, :school_id, :integer
    Ads.update_all({school_id:School.find_by_name('西南石油大学（新都校区）').id})
  end
end
