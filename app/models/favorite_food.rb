class FavoriteFood < ActiveRecord::Base
  belongs_to :user
  belongs_to :food
  #用来保证用户收藏的店家id唯一
  validates_uniqueness_of :food_id, :scope => :user_id
  
  #根据foodid获取favorite_id的方法
  def self.get_fav_food_by_food_id(food_id)
    FavoriteFood.where(:food_id => food_id).first
  end
end
